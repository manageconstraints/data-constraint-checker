class Version_class
	attr_accessor  :app_dir, :commit, :total_constraints_num, :db_constraints_num, :model_constraints_num, :html_constraints_num
	def initialize(app_dir, commit)
		@app_dir = app_dir
		@commit = commit.strip
		@files = {}
		@activerecord_files = {}
		@total_constraints_num = 0
		@db_constraints_num = 0
		@model_constraints_num = 0
		@html_constraints_num = 0
		@db_constraints = []
		@model_constraints = []
		@html_constraints = []
	end
	def getDbConstraints
		return @db_constraints
	end
	def getModelConstraints
		return @model_constraints
	end
	def getHtmlConstraints
		return @html_constraints
	end
	def extract_files
		if @app_dir and @commit
			@files = read_constraint_files(@app_dir, @commit)
		end
	end
	def extract_constraints
		# extract the constraints from the active record file
		@activerecord_files = @files.select{|key, x| x.is_activerecord}

		@activerecord_files.each do |key, file|
			# puts"#{key} #{file.getConstraints.length}"
			file.create_con_from_column_type
			file.create_con_from_index
			file.create_con_from_format
			file.getConstraints.each do |k, constraint|
				if constraint.type == Constraint::DB
					@db_constraints_num += 1
					@db_constraints << constraint
				end
				if constraint.type == Constraint::MODEL
					@model_constraints_num += 1
					@model_constraints << constraint
				end
				if constraint.type == Constraint::HTML
					@html_constraints_num += 1
					@html_constraints << constraint
				end
			end
		end
		@total_constraints_num = @db_constraints_num + @model_constraints_num + @html_constraints_num
	end
  def extract_case_insensitive_columns
    ci_columns = {}
    @activerecord_files.each do |key, file|
      constraints = file.getConstraints
      validation_constraints = constraints.select{|k,v| k.include?Constraint::MODEL}
      uniqueness_constraints = validation_constraints.select{|k,v| v.instance_of?Uniqueness_constraint and v.case_sensitive == false}
      puts "uniqueness_constraints #{uniqueness_constraints.size}"

      columns = file.getColumns
      puts "Columns #{file.class_name} #{columns.map{|k,v| v.column_name}.join(" ,")}" if columns.size > 0
      uniqueness_constraints.each do |k, v|
        column_name = v.column
        if columns[column_name]
          key = "#{file.class_name}-#{column_name}"
          ci_columns[key] = columns[column_name]
        end
      end
    end
    return ci_columns
	end
	def annotate_model_class
		not_active_files =[]
		@files.values.each do |file|
			if ["ActiveRecord::Base","Spree::Base"].include?file.upper_class_name
				file.is_activerecord = true
			else
				not_active_files << file
			end
		end
		while(true)
			length = not_active_files.length
			not_active_files.each do |file|
				key = file.upper_class_name
				if @files[key] and @files[key].is_activerecord
					file.is_activerecord = true
					not_active_files.delete(file)
				end
			end
			if not_active_files.length == length
				break
			end
		end
	end
	def get_activerecord_files
		return @activerecord_files
	end
	def print_columns
		# puts"---------------columns-----------------"
		get_activerecord_files.each do |key, file|
			# puts"#{key} #{file.getColumns.length}"
			file.getColumns.each do |key, column|
				# puts"\t#{column.column_name}"
			end
		end
	end
	def compare_constraints(old_version)
		newly_added_constraints = []
		changed_constraints = []
		existing_column_constraints = []
		new_column_constraints = []
		not_match_html_constraints = []
		@activerecord_files.each do |key, file|
			old_file = old_version.get_activerecord_files[key]
			# if the old file doesn't exist, which means it's newly created
			next unless old_file
			constraints = file.getConstraints
			old_constraints = old_file.getConstraints
			old_columns = old_file.getColumns
			constraints.each do |column_keyword, constraint|
				if old_constraints[column_keyword]
					if !constraint.is_same(old_constraints[column_keyword])
						changed_constraints << constraint
						if constraint.type == Constraint::HTML and (not is_html_constraint_match_validate(old_constraints, column_keyword, constraint))
							not_match_html_constraints << constraint
						end
					end
				else
					newly_added_constraints << constraint
					column_name = constraint.column
					if old_columns[column_name]
						existing_column_constraints << constraint
					else
						new_column_constraints << constraint
					end
					if constraint.type == Constraint::HTML and (not is_html_constraint_match_validate(old_constraints, column_keyword, constraint))
						not_match_html_constraints << constraint
					end
				end
			end
		end
		return newly_added_constraints,changed_constraints,existing_column_constraints,new_column_constraints,not_match_html_constraints
	end
  def is_html_constraint_match_validate(old_constraints, column_keyword, constraint)
		key = column_keyword.gsub(Constraint::HTML, Constraint::MODEL)
		key2 = column_keyword.gsub(Constraint::HTML, Constraint::DB)
		old_model_constraint =  old_constraints[key]
		old_db_constraint = old_constraints[key2]
		if  constraint.is_same_notype(old_model_constraint) or constraint.is_same_notype(old_db_constraint)
			return true
		end
		return false
	end
	def compare_self
		absent_cons = {}
		puts "@activerecord_files: #{@activerecord_files.length}"
		total_constraints = @activerecord_files.map{|k,v| v.getConstraints.length}.reduce(:+)
		db_cons_num = 0
		model_cons_num = 0
		html_cons_num = 0
		mm_cons_num = 0
    absent_cons2 = {}
    mm_cons_num2 = 0
		@activerecord_files.each do |key, file|
			constraints = file.getConstraints
			model_cons = constraints.select{|k,v| k.include?"-#{Constraint::MODEL}"}
			db_cons = constraints.select{|k,v| k.include?"-#{Constraint::DB}"}
			html_cons = constraints.select{|k,v| k.include?"-#{Constraint::HTML}"}
			model_cons_num += model_cons.length
			db_cons_num += db_cons.length
			html_cons_num += html_cons.length
			db_cons.each do |k, v|
				k2 = k.gsub("-db","-validate")
        k3 = k2.gsub("-#{v.class.name}-", "-#{Customized_constraint.to_s}-")
				puts "k2 #{k2}"
				begin
					column_name = v.column
					column = file.getColumns[column_name]
					db_filename = column.file_class.filename
				rescue
					column_name = "nocolumn"
					db_filename = "nofile"
        end
        next unless column # if the column doesn't exist
        next if column.is_deleted # if the column is deleted
        # if column is auto increment, then uniquness constraint and presence constraint are not needed in models
        if v.instance_of?Uniqueness_constraint or v.instance_of?Presence_constraint
          if column.auto_increment
            next
          end
        end
        # if column has default value, then the presence constraint is not needed.
        if v.instance_of?Presence_constraint
          if column.default_value
            next
          end
        end
        if model_cons[k3]
          puts "customized constraints"
          next
        end
				unless model_cons[k2]
					absent_cons[k] = v
					v.self_print
					puts "absent: #{column_name} #{v.table} #{db_filename} #{v.class.name} #{@commit}"
				else
					v2 = model_cons[k2]
					if v.is_a?Length_constraint
						if (v2.max_value and v.max_value  and v2.max_value != v.max_value)
							puts "mismatch constraint max #{v.table}  #{v.max_value} #{v2.max_value} #{column_name} #{db_filename} #{@commit}"
						end
						if (v2.min_value and v.min_value  and v2.min_value != v.min_value)
							puts "mismatch constraint min #{v.table}  #{v.min_value} #{v2.min_value} #{column_name} #{db_filename} #{@commit}"
						end
						v.self_print
					end
					if not v.is_same_notype(v2)
						puts "mismatch constraint #{db_filename} #{@commit} #{v.class.name} #{v.table} #{v.to_string} #{v2.to_string}"
						mm_cons_num += 1
					end
				end
      end

			model_cons.each do |k, v|
				k2 = k.gsub("-#{Constraint::MODEL}","-#{Constraint::HTML}")
				puts "k2 #{k2}"
				begin
					column_name = v.column
					column = file.getColumns[column_name]
					model_filename = column.file_class.filename
				rescue
					column_name = "nocolumn"
          model_filename = "nofile"
				end
				unless html_cons[k2]
          absent_cons2[k] = v
					v.self_print
					puts "absent2: #{column_name} #{v.table} #{model_filename} #{v.class.name} #{@commit}"
				else
					v2 = html_cons[k2]
					if v.is_a?Length_constraint
						if (v2.max_value and v.max_value  and v2.max_value != v.max_value)
							puts "mismatch constraint max #{v.table}  #{v.max_value} #{v2.max_value} #{column_name} #{model_filename} #{@commit}"
						end
						if (v2.min_value and v.min_value  and v2.min_value != v.min_value)
							puts "mismatch constraint min #{v.table}  #{v.min_value} #{v2.min_value} #{column_name} #{model_filename} #{@commit}"
						end
						v.self_print
					end
					if not v.is_same_notype(v2)
						puts "mismatch constraint #{model_filename} #{@commit} #{v.class.name} #{v.table} #{v.to_string} #{v2.to_string}"
            mm_cons_num2 += 1
					end
				end
			end
		end
		puts "total absent: #{absent_cons.size} total_constraints: #{total_constraints} model_cons_num: #{model_cons_num} db_cons_num: #{db_cons_num} mm_cons_num: #{mm_cons_num}"
    puts "total absent2: #{absent_cons2.size} total_constraints: #{total_constraints} html_cons_num: #{html_cons_num} model_cons_num: #{model_cons_num}  mm_cons_num2: #{mm_cons_num2}"

  end
	def build
		self.extract_files
		self.annotate_model_class
		self.extract_constraints
		self.print_columns
    puts "@active_files : #{@activerecord_files.size}"

	end
end

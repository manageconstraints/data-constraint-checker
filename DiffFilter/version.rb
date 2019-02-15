class Version
	attr_accessor  :app_dir, :commit
	def initialize(app_dir, commit)
		@app_dir = app_dir
		@commit = commit
		@files = {}
	end
	def extract_files
		if @app_dir and @commit 
			@files = read_ruby_files(@app_dir, commit)
		end
	end
	def extract_constraints
		# extract the constraints from the active record file
		active_files = @files.select{|key, x| x.is_activerecord}
		puts "@files.length: #{@files.length}"
		puts "@active_files.length: #{active_files.length}"
		active_files.each do |key, file|
			puts "#{key} #{file.getConstraints.length}"
		end
	end
	def annotate_model_class
		not_active_files =[]
		@files.values.each do |file|
			if file.upper_class_name == "ActiveRecord::Base"
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
					not_active_files.remove(file)
				end
			end
			if not_active_files.length == length
				break
			end
		end
	end
end
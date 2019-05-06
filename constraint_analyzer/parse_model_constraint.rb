def parse_model_constraint_file(ast)
	if ast.type.to_s == 'list'
		ast.children.each do |child|
			parse_model_constraint_file(child)
		end
	end
	if ast.type.to_s == 'module'
		if ast[1] and ast[1].type.to_s == "list"
			ast[1].each do |child|
				parse_model_constraint_file(child)
			end
		end
	end
	if ast.type.to_s == 'class'
		c1 =  ast.children[0]
		c2 = ast.children[1] 
		if c1 and c1.type.to_s == 'const_ref'
			$cur_class.class_name = c1.source
		end
		if c2 and (c2.type.to_s == 'var_ref' or c2.type.to_s == 'const_path_ref')
			$cur_class.upper_class_name = c2.source
		end
		# puts"filename: #{$cur_class.filename} "
		# puts"classname: #{$cur_class.class_name} upper_class_name: #{$cur_class.upper_class_name}"
		c3 = ast.children[2]
		if c3
			parse_model_constraint_file(c3)
		end
	end
	if ast.type.to_s == "command"
		funcname = ast[0].source 
		if $validate_apis and $validate_apis.include?funcname
			# puts"funcname #{funcname} #{ast.source}"
			constraints = parse_validate_constraint_function($cur_class.class_name, funcname, ast[1])
			$cur_class.addConstraints(constraints) if constraints.length > 0
		end
	end
end



def parse_validate_constraint_function(table, funcname, ast)
	type = Constraint::MODEL
	constraints = []
	if funcname == "validates" or funcname == "validates!"
		constraints += parse_validates(table, funcname, ast)
	elsif funcname.include?"_"
		columns = []
		dic = {}
		ast.children.each do |child|
			if child.type.to_s == 'symbol_literal'
				column = handle_symbol_literal_node(child)
				columns << column
			end
			# puts"child.type.to_s #{child.type.to_s} #{child.source}"
			if child.type.to_s == "list"
				child.each do |c|
					if c.type.to_s == 'assoc'
						key, value = handle_assoc_node(c)
						if key and value
							dic[key] = value 
						end
					end
				end
			end
		end
		allow_blank = false
		allow_nil = false
		if dic["allow_blank"] and dic["allow_blank"].source == "true"
			allow_blank = true
		end
		if dic["allow_nil"] and dic["allow_nil"].source == "true"
			allow_nil = true
		end
		if columns.length > 0
			if funcname == "validates_exclusion_of"
				columns.each do |column|
					constraint = Exclusion_constraint.new(table, column, type, allow_nil, allow_blank)
					constraint.parse(dic)
					constraints << constraint
				end
			end
			if funcname == "validates_inclusion_of"
				columns.each do |column|
					constraint = Inclusion_constraint.new(table, column, type, allow_nil, allow_blank)
					constraint.parse(dic)
					constraints << constraint
				end
			end
			if funcname == "validates_presence_of"
				columns.each do |column|
					constraint = Presence_constraint.new(table, column, type, allow_nil, allow_blank)
					constraints << constraint
				end
			end
			if funcname == "validates_length_of" or funcname == "validates_size_of"
				columns.each do |column|
					constraint = Length_constraint.new(table, column, type, allow_nil, allow_blank)
					constraint.parse(dic)
					constraints << constraint
				end
			end
			if funcname == "validates_format_of"
				columns.each do |column|
					constraint = Format_constraint.new(table, column, type, allow_nil, allow_blank)
					constraint.parse(dic)
					constraints << constraint
				end
			end
			if funcname == "validates_uniqueness_of"
				columns.each do |column|
					constraint = Uniqueness_constraint.new(table, column, type, allow_nil, allow_blank)
					constraint.parse(dic)
					constraints << constraint
				end
			end
			if funcname == "validates_numericality_of"
				columns.each do |column|
					constraint = Numericality_constraint.new(table, column, type, allow_nil, allow_blank)
					constraint.parse(dic)
					constraints << constraint
				end
			end
			if funcname == "validates_acceptance_of"
				columns.each do |column|
					constraint = Acceptance_constraint.new(table, column, type)
					constraint.parse(dic)
					constraints << constraint
				end
			end
		end
	end
	return constraints
end


def parse_validates(table, funcname, ast)
	type = "validate"
	constraints = []
	columns = []
	cur_constrs = []
	puts "ast: #{ast&.children&.length}"
	ast.children.each do |child|
  		if child.type.to_s == 'symbol_literal'
  			column = handle_symbol_literal_node(child)
  			columns << column
  		end
  		if child.type.to_s == 'list'
				child.each do |c|
          node = c
          if node.type.to_s == "assoc"
            cur_constr, cur_value_ast = handle_assoc_node(node)
            puts "cur_constr #{cur_constr}"
            next unless cur_constr
          if cur_value_ast.type.to_s == "hash"
            dic = handle_hash_node(cur_value_ast)
          end
            if cur_constr == "presence"
            cur_value = cur_value_ast.source
            if cur_value == "true"
              columns.each do |c|
                constraint = Presence_constraint.new(table, c, type)
                constraints << constraint
              end
            end
          end
          if cur_constr == "format"
            if dic
              columns.each do |c|
                constraint = Format_constraint.new(table, c, type)
                  constraint.parse(dic)
                  constraints << constraint
                end
            end
          end
          if cur_constr == "inclusion"
            cur_value = cur_value_ast.source
            columns.each do |c|
              constraint = Inclusion_constraint.new(table, c, type)
              constraint.range = cur_value
              constraints << constraint
            end
          end
          if cur_constr == "exclusion"
            cur_value = cur_value_ast.source
            columns.each do |c|
              constraint = Exclusion_constraint.new(table, c, type)
              constraint.range = cur_value
              constraints << constraint
            end
          end
          if cur_constr == "length"
            if dic
              columns.each do |c|
                constraint = Length_constraint.new(table, c, type)
                constraint.parse(dic)
                constraints << constraint
              end
            end
          end
          if cur_constr == "numericality"
            if cur_value_ast&.source == "true"
              dic = {}
            end
            if dic
              columns.each do |c|
                constraint = Numericality_constraint.new(table, c, type)
                constraint.parse(dic)
                constraints << constraint
              end
            end
          end
          if cur_constr == "uniqueness"
            if cur_value_ast.source == "true"
              dic = {}
            end
            if dic
              columns.each do |c|
                constraint = Uniqueness_constraint.new(table, c, type)
                constraint.parse(dic)
                constraints << constraint
              end
            end
          end
          if cur_constr == "acceptance"
            if cur_value_ast.source == "true"
              dic = {}
            end
            if dic
              columns.each do |c|
                constraint = Acceptance_constraint.new(table, c, type)
                constraint.parse(dic)
                constraints << constraint
              end
            end
          end
          if cur_constr == "confirmation"
            cur_value = cur_value_ast.source
            if cur_value == "true"
              dic = {}
            end
            if dic
              columns.each do |c|
                constraint = Confirmation_constraint.new(table, c, type)
                constraint.parse(dic)
                constraints << constraint
              end
            end
          end
          end
        end

      end
	end
	return constraints
end




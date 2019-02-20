require 'yard'
require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext/string'
def parse_model_constraint_file(ast)
	if ast.type.to_s == 'list'
		ast.children.each do |child|
			parse_model_constraint_file(child)
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
		puts "filename: #{$cur_class.filename} "
		puts "classname: #{$cur_class.class_name} upper_class_name: #{$cur_class.upper_class_name}"
		c3 = ast.children[2]
		if c3
			parse_model_constraint_file(c3)
		end
	end
	if ast.type.to_s == "command"
		funcname = ast[0].source 
		if $validate_apis.include?funcname
			puts "funcname #{funcname} #{ast.source}"
			constraints = parse_validate_constraint_function($cur_class.class_name, funcname, ast[1])
			$cur_class.add_constraints(constraints) if constraints.length > 0
		end
	end
end

def parse_db_constraint_file(ast)
	if ast.type.to_s == 'list'
		ast.children.each do |child|
			parse_db_constraint_file(child)
		end
	end
	if ast.type.to_s == 'class'
		puts "ast.children #{ast.children[0].source}"
		c3 = ast.children[2]
		if c3
			puts "c3: #{c3.type}"
			parse_db_constraint_file(c3)
		end
	end
	if ast.type.to_s == "def" or ast.type.to_s == "defs"
		funcname = ast[0].source
		if ast[1] and ast[1].type.to_s == "period"
			funcname = ast[2].source
		end
		puts "funcname: #{funcname} "
		if !funcname.include?"down"
			parse_db_constraint_file(ast[-1])
		end
	end
	if ast.type.to_s == "command"
		funcname = ast[0].source 
		puts "callname: #{funcname}"
		if funcname == "add_column"
			handle_add_column(ast[1])
		end
		if funcname == "create_table"
			handle_create_table(ast)
		end
		if funcname == "change_column"
			handle_change_column(ast[1])
		end
		if funcname == "change_table"
			handle_change_table(ast)
		end
		
	end
end

def parse_validate_constraint_function(table, funcname, ast)
	type = "validate"
	constraints = []
	if funcname == "validates"
		constraints += parse_validates(table, funcname, ast)
	elsif funcname.include?"_"
		columns = []
		dic = {}
		ast.children.each do |child|
			if child.type.to_s == 'symbol_literal'
				column = handle_symbol_literal_node(child)
				columns << column
			end
			puts "child.type.to_s #{child.type.to_s} #{child.source}"
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
			if funcname == "validates_length_of"
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
		end
	end
	return constraints
end

def parse_db_constraint_function(table, funcname, ast)
end

def parse_validates(table, funcname, ast)
	type = "validate"
	constraints = []
	columns = []
	cur_constrs = []
	ast.children.each do |child|
  		if child.type.to_s == 'symbol_literal'
  			column = handle_symbol_literal_node(child)
  			columns << column
  		end
  		if child.type.to_s == 'list'
  			node = child[0]
  			if node.type.to_s == "assoc"
  				cur_constr, cur_value_ast = handle_assoc_node(node)
  				next unless cur_constr
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
					if cur_value_ast.type.to_s == "hash"
						dic = handle_hash_node(cur_value_ast)
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
  			end
  		end
	end
	return constraints
end
def convert_tablename(name)
	_name = Array.new
	_word_list = Array.new
	name.split('').each do |c|
		if c == '_'
			_word_list.push(_name.join)
			_name = Array.new
		else
			_name.push(c)
		end
	end
	_word_list.push(_name.join)
	_word_list.each do |w|
		w[0] = w[0].capitalize
	end
	_word_list[-1] = _word_list[-1].singularize
	temp_name = _word_list.join
	return temp_name
end

def handle_hash_node(node)
	dic = {}
	node.children.each do |child|
		if child.type.to_s == "assoc"
			key, value = handle_assoc_node(child)
			if key and value
				dic[key] = value
			end
		end
	end
	return dic
end
def handle_assoc_node(child)
	key = nil
	value = nil
	if child[0].type.to_s == "symbol_literal"
		key = handle_symbol_literal_node(child[0])
	end
	if child[0].type.to_s == "label"
		key = handle_label_node(child[0])
	end
	value = child[1]
	#puts "key: #{key} value: #{value.source}"
	return key,value
end 

def handle_symbol_literal_node(symbol)
	return symbol[0][0].source
end

def handle_label_node(label)
	return label[0]
end

def handle_change_table(ast)
	handle_create_table(ast)
end

def handle_add_column(ast)
	handle_change_column(ast)
end

def handle_change_column(ast)
	children = ast.children
	puts "ast.source #{ast.source}"
	table = nil
	column_name = nil
	column_type = nil
	if children[0] and children[0].type.to_s == "symbol_literal"
		table = handle_symbol_literal_node(children[0])
	end
	if children[1] and children[1].type.to_s == "symbol_literal"
		column_name = handle_symbol_literal_node(children[1])
	end
	if children[2] and children[2].type.to_s == "symbol_literal"
		column_type = handle_symbol_literal_node(children[2])
	end
	dic = {}
	if children[3] and children[3].type.to_s == "list"
		children[3].children.each do |child|
			if child.type.to_s == "assoc"
				key, value = handle_assoc_node(child)
				dic[key] = value
			end
		end
	end
	class_name = convert_tablename(table)
	if table and column_name and column_type and $model_classes[class_name] 
		table_class = $model_classes[class_name]
		column = Column.new(table_class, column_name, column_type, $cur_class)
		columns = table_class.getColumns
		if columns[column_name]
			# existing columns
			column.prev_column =  columns[column_name]
		end
		table_class.addColumn(column)
		puts "create new column #{column.class.name} #{table_class.class_name} #{column_name} #{column_type}"
		if !dic["default"] and dic["null"]
			null = dic["null"].source
			if null == "false"
				constraint = Presence_constraint.new(class_name, column_name, "db")			
			end
		end
	end
	puts "table: #{table} column: #{column} column_type: #{column_type}"
end

def handle_create_table(ast)
	table_name = nil
	puts "handle_create\n#{ast.source}"
	puts "ast[1] #{ast[1].source} #{ast[1].type.to_s}"
	if ast[1].type.to_s == "list"
		symbol_node = ast[1][0]
		table_name = handle_symbol_literal_node(symbol_node)
		class_name = convert_tablename(table_name)
		puts "class_name: #{class_name}"
		table_class = $model_classes[class_name]
		unless table_class
			return
		end
		columns = table_class.getColumns
		#puts "table_name: #{table_name}"
		if ast[2].type.to_s == "do_block"
			ast[2].children.each do |child|
				if child.type.to_s == 'list'
					child.children.each do |c|
						if c.type.to_s == "command_call"
							column_type = c[2].source
							if column_type == "references"
								column_type = "string"
							end
							column_ast = c[3]
							puts "column_ast: #{column_ast.class}"
							if column_ast.class.name == "YARD::Parser::Ruby::AstNode" and  column_ast.type.to_s == "list"
								column_name = handle_symbol_literal_node(column_ast[0])
								column = Column.new(table_class, column_name, column_type, $cur_class)
								if columns[column_name]
									# existing columns
									column.prev_column =  columns[column_name]
								end
								table_class.addColumn(column)
								dic = {}
								if column_ast[1].class.name == "YARD::Parser::Ruby::AstNode" and column_ast[1].type and column_ast[1].type.to_s == "list"
									column_ast[1].children.each do |cc|
										if cc.type.to_s == "assoc"
											key, value = handle_assoc_node(cc)
											dic[key] = value
										end
									end
								end
								puts "-----------dic---------"
								puts dic
								if !dic["default"] and dic["null"]
									null = dic["null"].source
									if null == 'false'
										constraint = Presence_constraint.new(class_name, column_name, "db")
										puts "*****create new presence constraint*****"
									end
								end
							end
						end
					end
				end
			end
		end
	end

end
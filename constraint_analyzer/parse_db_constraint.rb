def parse_db_constraint_file(ast)
	if ast.type.to_s == 'list'
		ast.children.each do |child|
			parse_db_constraint_file(child)
		end
	end
	if ast.type.to_s == 'class'
		# puts"ast.children #{ast.children[0].source}"
		c3 = ast.children[2]
		if c3
			# puts"c3: #{c3.type}"
			parse_db_constraint_file(c3)
		end
	end
	if ast.type.to_s == "def" or ast.type.to_s == "defs"
		funcname = ast[0].source
		if ast[1] and ast[1].type.to_s == "period"
			funcname = ast[2].source
		end
		# puts"funcname: #{funcname} "
		if !funcname.include?"down"
			parse_db_constraint_file(ast[-1])
		end
	end
	if ast.type.to_s == "fcall" and ast[0].source == "reversible"
		handle_reversible(ast)
	end
	if ast.type.to_s == "command"
		funcname = ast[0].source 
		# puts"callname: #{funcname}"
		parse_db_constraint_function(nil, nil, funcname)
	end
end
def parse_db_constraint_function(table, funcname, ast)
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
	if funcname == "change_column_null"
		handle_change_column_null(ast)
	end
	if funcname == "execute"
		parse_sql(ast[1])
	end
		
end
def handle_change_table(ast)
	handle_create_table(ast)
end

def handle_add_column(ast)
	handle_change_column(ast)
end

def handle_change_column(ast)
	children = ast.children
	# puts"ast.source #{ast.source}"
	table = nil
	column_name = nil
	column_type = nil
	table = handle_symbol_literal_node(children[0])
	column_name = handle_symbol_literal_node(children[1])
	column_type = handle_symbol_literal_node(children[2])
	dic = {}
	dic = extract_hash_from_list(children[3])
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
		# puts"create new column #{column.class.name} #{table_class.class_name} #{column_name} #{column_type}"
		constraints = create_constraints(class_name, column_name, column_type, "db", dic)
		table_class.addConstraints(constraints)
	end
	# puts"table: #{table} column: #{column} column_type: #{column_type}"
end

def handle_create_table(ast)
	table_name = nil
	# puts"handle_create\n#{ast.source}"
	# puts"ast[1] #{ast[1].source} #{ast[1].type.to_s}"
	if ast[1].type.to_s == "list"
		symbol_node = ast[1][0]
		table_name = handle_symbol_literal_node(symbol_node)
		class_name = convert_tablename(table_name)
		# puts"class_name: #{class_name}"
		table_class = $model_classes[class_name]
		unless table_class
			return
		end
		columns = table_class.getColumns
		## puts"table_name: #{table_name}"
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
							# puts"column_ast: #{column_ast.class}"
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
								# puts"-----------dic---------"
								# putsdic
								constraints = create_constraints(class_name, column_name, column_type, "db", dic)
								table_class.addConstraints(constraints)
							end
						end
					end
				end
			end
		end
	end

end
def handle_change_column_null(ast)
	puts "++++++++++handle_change_column_null++++++++++"
	if ast[1].type.to_s == "list"
		table_name = nil
		column_name = nil
		null = true
		table_class = nil
		class_name = nil
		if ast[1][0].type.to_s == "symbol_literal"
			table_name = handle_symbol_literal_node(ast[1][0])
			class_name = convert_tablename(table_name)
			table_class = $model_classes[class_name]
		end
		if ast[1][1].type.to_s == "symbol_literal"
			column_name = handle_symbol_literal_node(ast[1][0])
		end
		if ast[1][2].type.to_s == "var_ref"
			null = ast[1][2].source
		end
		if class_name and table_class and column_name and null == "false"
			constraint = Presence_constraint.new(class_name, column_name, "db")
			table_class.addConstraints([constraint])
		end
	end
end
def handle_reversible(ast)
	table_name = nil
	column_name = nil
	null = true
	table_class = nil
	class_name = nil
	dic = {}
	return unless ast[-1].type.to_s == "do_block"
	list_ast = ast[-1][-1]
	return unless list_ast&.type.to_s == "list"
	list_ast.children.each do |child|
		next unless child.type.to_s == "command"
		puts "#{child[1].type.to_s} child1 #{child[1][0].type.to_s}"
		next if !(child[1].type.to_s == "list" and child[1][0].type.to_s == "symbol_literal")
		table_name = handle_symbol_literal_node(child[1][0])
		class_name = convert_tablename(table_name)
		table_class = $model_classes[class_name]
		puts "table_name : #{table_name}"
		next unless child[-1].type.to_s == "do_block"
		if child[-1][-1].type.to_s == "list"
			child[-1][-1].children.each do |cc|
				next unless cc.type.to_s == "call"
				next unless cc[2].source == "up"
				next unless cc[-1].type.to_s == "brace_block"
				next unless cc[-1][1][0]&.type.to_s == "command_call"
				ccc = cc[-1][1][0][-1]
				next unless ccc&.type.to_s == "list"
				column_name = handle_symbol_literal_node(ccc[0])
				column_type = handle_symbol_literal_node(ccc[1])
				dic == extract_hash_from_list(ast)
				old_column = table_class.getColumns[column_name]
				next if !(column_name and table_class and column_name) 
				column = Column.new(table_class, column_name, column_type, $cur_class)
				column.prev_column = old_column
				table_class.addColumn(column)
				constraints = create_constraints(class_name, column_name, column_type, "db", dic)
				table_class.addConstraints(constraints)	
			end
		end
	end
end
def create_constraints(class_name, column_name, column_type, type, dic)
	return [] unless dic
	return [] unless dic.length > 0
	constraints = []
	if  dic["null"]
		null = dic["null"].source
		if null == "false"
			constraint = Presence_constraint.new(class_name, column_name, type)			
			constraints << constraint
		end
	end
	# 
	if dic['limit']
		limit = dic["limit"].source
		constraint = Length_constraint.new(class_name, column_name, type)
		constraint.max_value = limit
		constraints << constraint
	end
	return constraints
end
def parse_html_constraint_file(ast)
	puts "ast.type.to_s #{ast.type.to_s}"
	table = ""
	if ast.type.to_s == 'list'
		ast.children.each do |child|
			puts "child.type.to_s #{child.type.to_s}"
			parse_html_constraint_file(child)
		end
	end
	if ast.type.to_s == "fcall"
		funcname = ast[0].source 
		if $html_constraint_api.include?funcname
			parse_html_constraint_function(table, funcname, ast)
		end
		ast.children.each do |child|
			parse_html_constraint_file(child)
		end
	end
	if ast.type.to_s == "command"
		funcname = ast[0].source
		if $html_constraint_api.include?funcname
			parse_html_constraint_function(table, funcname, ast)
		end
		ast.children.each do |child|
			parse_html_constraint_file(child)
		end
	end
	if ast.type.to_s == "command_call"
		funcname = ast[2]&.source
		if $html_constraint_api.include?funcname and ast[3]&.type.to_s == "list"
			parse_html_constraint_function(table, funcname, ast)
		end
	end
	if ast.type.to_s == "do_block"

		ast.children.each do |child|
			if child.type.to_s == "list"
				child.children.each do |c|
					parse_html_constraint_file(c)
				end
			end
		end
	end
end
def parse_html_constraint_function(table, funcname, ast)
	puts "parse_html_constraint_function #{funcname}"
  if ast.type.to_s == "command_call"
    param_ast = ast[3]
  else
    param_ast = ast[1]
    param_ast = ast[1][0] if ast[1].type.to_s == "arg_paren"
  end
	symbols = []
	dic = {}

  param_ast.children.each do |child|
    puts "child #{child.type.to_s} #{child.source}"
		if child.type.to_s == "string_literal"
			symbol = handle_string_literal_node(child)
			symbols << symbol
    end
    if child.type.to_s == "symbol_literal"
      symbol = handle_symbol_literal_node(child)
      symbols << symbol
    end
		if child.type.to_s == "list"
			dic = extract_hash_from_list(child)
		end
	end
	puts symbols
	puts dic

end
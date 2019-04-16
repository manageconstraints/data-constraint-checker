def parse_html_constraint_file(ast)
	if ast.type.to_s == 'list'
		ast.children.each do |child|
			parse_html_constraint_file(child)
		end
	end
	if ast.type.to_s == "fcall"
		funcname = ast[0].source 
		if $html_constraint_api.include?funcname
			if ast[1].type.to_s == "arg_paren"
			end
		end
		ast.children.each do |child|
			parse_html_constraint_file(child)
		end
	end
	if ast.type.to_s == "command"
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
end
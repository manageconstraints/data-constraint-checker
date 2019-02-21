require 'pg_query'

def parse_sql(ast)
	if ast.type.to_s == "list"
		string_literal_node = ast[0]
		if string_literal_node.type.to_s == "string_literal"
			query_node = string_literal_node[0]
			if query_node.type.to_s == "string_content"
				
			end
		end
	end
end


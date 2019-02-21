require 'pg_query'

def parse_sql(ast)
	if ast.type.to_s == "list"
		string_literal_node = ast[0]
		if string_literal_node.type.to_s == "string_literal"
			query_node = string_literal_node[0]
			if query_node.type.to_s == "string_content"
				sql = query_node.source
				parse_sql_string(sql)
			end
		end
	end
end
# use pg query to handle sql query string
def parse_sql_string(sql)
	sql_ast = PgQuery.parse(sql)
	tree = sql_ast[0]['RawStmt']['stmt']
	if tree['UpdateStmt']
	end
end


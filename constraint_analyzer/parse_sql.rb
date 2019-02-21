require 'pg_query'
require 'yard'
def parse_sql(ast)
	if ast.type.to_s == "list"
		string_literal_node = ast[0]
		if string_literal_node.type.to_s == "string_literal"
			query_node = string_literal_node[0]
			if query_node.type.to_s == "string_content"
				sql = query_node.source
				return parse_sql_string(sql)
			end
		end
	end
end
# use pg query to handle sql query string
def parse_sql_string(sql)
	sql_ast = PgQuery.parse(sql)
	puts "sql: #{sql}"
	tree = sql_ast.tree[0]['RawStmt']['stmt']
	table_name = nil 
	columns =[]
	if tree['UpdateStmt']
		update_query = tree['UpdateStmt']
		begin
			table_name = update_query['relation']['RangeVar']['relname']
		rescue
		end
		update_query['targetList'].each do |v|
			begin 
				column = v['ResTarget']['name']
				columns << column
			rescue
			end
		end
	end
	return table_name, columns
end

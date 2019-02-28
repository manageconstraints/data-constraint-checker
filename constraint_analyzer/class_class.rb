class Class_class
	attr_accessor :filename, :class_name, :upper_class_name, :ast, :is_activerecord, :is_deleted, :indices
	def initialize(filename)
		@filename = filename
		@is_activerecord = false
		@class_name = nil
		@upper_class_name = nil
		@ast = nil
		@constraints = {}
		@columns = {}
		@is_deleted = false
		@indices = {}
	end
	def addConstraints(constraints)
		constraints.each do |constraint|
			# puts"constraint #{constraint.class}"
			key = "#{constraint.column}-#{constraint.class.name}-#{constraint.type}"
			@constraints[key] = constraint
			constraint.table = self.class_name
		end
		# puts"@constraints.size #{@constraints.length}"
	end
	def getConstraints
		return @constraints
	end
	def getColumns
		return @columns
	end
	def addColumn(column)
		@columns[column.column_name] = column
	end
	def addIndex(index)
		@indices[index.name] = index
	end
end
class Column
	attr_accessor :column_type,  :column_name, :file_class, :prev_column, :is_deleted, :default_value, :table_class
	def initialize(table_class, column_name, column_type, file_class, dic={})
		@table_class = table_class
		@column_name = column_name
		@column_type = column_type
		@is_deleted = false
		self.parse(dic)
	end
	def getTableClass
		return @table_class
	end
	def setTable(table_class)
		@table_class = table_class
	end
	def parse(dic)
		puts "dic #{dic['default']&.type}"
		ast = dic["default"]
		value = dic["default"]&.source if dic["default"]&.type.to_s == "var_ref"
		@default_value = value || handle_symbol_literal_node(ast) || handle_string_literal_node(ast)
	end
end
class Index
	attr_accessor :name, :table_name, :columns, :unique
	def initialize(name, table_name, columns)
		@name = name
		@table_name = table_name
		@columns = columns
		@unique = false
	end
end
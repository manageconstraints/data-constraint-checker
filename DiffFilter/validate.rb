class Constraint
	attr_accessor :table, :column, :type, :if, :unless, :allow_nil, :allow_blank
	#type: model from validate function / db migration file 
	def initialize(table, column, type)
		@column = column
		@table = table
		@type = type
	end

end

class Length_constraint < Constraint
	attr_accessor :min_value, :max_value, :is_constraint, :range
end

class Format_constraint < Constraint
	attr_accessor :with_format, :on_condition

end

class Inclusion_constraint < Constraint

end

class Exclusion_constraint < Constraint

end

class Presence_constraint < Constraint

end

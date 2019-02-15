class Constraint
	attr_accessor :table, :column, :type, :if, :unless, :allow_nil, :allow_blank
	#type: model from validate function / db migration file 
	def initialize(table, column, type, allow_nil=false, allow_blank=false)
		@column = column
		@table = table
		@type = type
		puts "\tcreate new constraint #{self.class.name} #{table} #{column} "
	end

end

class Length_constraint < Constraint
	attr_accessor :min_value, :max_value, :is_constraint, :range
	def parse(dic)
		if dic["in"]
			range = dic["in"].source
			self.range = range
		end
		if dic["within"]
			range = dic["in"].source
			self.range = range
		end
		if dic["maximum"]
			maximum = dic["maximum"].source
			self.max_value = maximum
		end
		if dic["minimum"]
			minimum = dic["minimum"].source
			self.min_value = minimum
		end
	end
end

class Format_constraint < Constraint
	attr_accessor :with_format, :on_condition
	def parse(dic)
		if dic["with"]
			with_format = dic["with"].source
			self.with_format = with_format
		end
	end
end

class Inclusion_constraint < Constraint
	attr_accessor :range
	def parse(dic)
		if dic["in"]
			range = dic["in"].source
			self.range = range
		end
	end
end

class Exclusion_constraint < Constraint
	attr_accessor :range
	def parse(dic)
		if dic["in"]
			range = dic["in"].source
			self.range = range
		end
	end
end

class Presence_constraint < Constraint

end

class Constraint
	attr_accessor :table, :column, :type, :if_cond, :unless_cond, :allow_nil, :allow_blank
	#type: model from validate function / db migration file 
	def initialize(table, column, type, allow_nil=false, allow_blank=false)
		@column = column
		@table = table
		@type = type
		@if_cond = nil
		@unless_cond = nil 
		@allow_blank = allow_blank
		@allow_nil = allow_nil
		puts "\tcreate new constraint #{self.class.name} #{table} #{column} "
	end
	def is_same(old_constraint)
		if old_constraint.class == self.class
			@table == old_constraint.table and \
			@column == old_constraint.column and \
			@type == old_constraint.type and \
			@if_cond == old_constraint.if_cond and \
			@unless_cond == old_constraint.unless_cond and \
			@allow_blank == old_constraint.allow_blank and \
			@allow_nil == old_constraint.allow_nil
			return true
		end
		return false 
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
	def is_same(old_constraint)
		if super
			if self.max_value = old_constraint.maximum and \
				self.min_value = old_constraint.min_value and \
				self.range = old_constraint.range and \
				self.is_constraint = old_constraint.is_constraint
				return true
			end
		end
		return false
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
	def is_same(old_constraint)
		if super
			if self.with_format == old_constraint.with_format and \
				self.on_condition == old_constraint.on_condition 
				return true
			end
		end
		return false
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
	def is_same(old_constraint)
		if super
			if self.range == old_constraint.range
				return true
			end
		end
		return false
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
	def is_same(old_constraint)
		if super
			if self.range == old_constraint.range
				return true
			end
		end
		return false
	end
end

class Presence_constraint < Constraint

end

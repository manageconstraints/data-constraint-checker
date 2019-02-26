class Constraint
	attr_accessor :table, :column, :type, :if_cond, :unless_cond, :allow_nil, :allow_blank, :is_new_column
	#type: model from validate function / db migration file 
	def initialize(table, column, type, allow_nil=false, allow_blank=false)
		@column = column
		@table = table
		@type = type
		@if_cond = nil
		@unless_cond = nil 
		@allow_blank = allow_blank
		@allow_nil = allow_nil
		@is_new_column = false
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
	def self_print
		puts "#{self.class.name} #{table} #{column} #{type}"
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
			if self.max_value == old_constraint.max_value and \
				self.min_value == old_constraint.min_value and \
				self.range == old_constraint.range and \
				self.is_constraint == old_constraint.is_constraint
				return true
			end
		end
		return false
	end
	def self_print
		super
		puts "\t#{max_value} #{min_value} #{range} #{is_constraint}" 
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
	def self_print
		super
		puts "\t#{with_format}"
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
	def self_print
		super
		puts "\t#{range}"
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
	def self_print
		super
		puts "\t#{range}"
	end
end

class Presence_constraint < Constraint

end

class Absence_constraint < Constraint

end

class Uniqueness_constraint < Constraint
	attr_accessor :scope
	def parse(dic)
		@scope = []
		if dic["scope"]
			scope_ast = dic["scope"]
			if scope_ast.type.to_s == "symbol_literal"
				column = handle_symbol_literal_node(scope_ast)
				scope << column
			end
			if scope_ast.type.to_s == "array"
				scope = handle_array_node(scope_ast)
			end
		end
	end
	def self_print
		super
		puts scope
	end
end

class Numericality_constraint < Constraint 

end
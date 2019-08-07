class Constraint
	DB = "db"
	MODEL = "validate"
	HTML = "html"
	attr_accessor :table, :column, :type, :if_cond, :unless_cond, :allow_nil, :allow_blank, :is_new_column, :custom_error_msg
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
		@custom_error_msg = false
	end
	def is_same(old_constraint)
		if @type == old_constraint.type and is_same_notype(old_constraint)
			return true
		end
		return false
	end
	def is_same_notype(old_constraint)
		if old_constraint.class == self.class
			@table == old_constraint.table and \
			@column == old_constraint.column and \
			@if_cond == old_constraint.if_cond and \
			@unless_cond == old_constraint.unless_cond and \
			@allow_blank == old_constraint.allow_blank and \
			@allow_nil == old_constraint.allow_nil
			return true
		end
		return false
	end
	def get_mismatch_fields(old_constraint)
		mismatch_fields = []
		if @if_cond != old_constraint.if_cond
			mismatch_fields << "if_cond"
		end
		if @unless_cond != old_constraint.unless_cond
			mismatch_fields << "unless_cond"
		end
		if @allow_blank != old_constraint.allow_blank
			mismatch_fields << "allow_blank-#{@allow_blank}-#{old_constraint.allow_blank}"
		end
		if @allow_nil != old_constraint.allow_nil
			mismatch_fields << "allow_nil-#{@allow_nil}-#{old_constraint.allow_nil}"
		end

		return mismatch_fields
	end

	def self_print
		puts to_string
	end
	def to_string
		return "#{self.class.name} #{table} #{column} #{type}"
	end
	def self.inherited(subclass)
		@descendants = [] if not @descendants
		@descendants << subclass
	end

	def self.descendants
		return @descendants
	end

	def parse(dic)
		if dic and dic.include? "message"
			@custom_error_msg = true
		end
	end
end

class Length_constraint < Constraint
	attr_accessor :min_value, :max_value, :is_constraint, :range
	def parse(dic)
		super
		if dic["in"]
			range = dic["in"].source
			self.range = range
		end
		if dic["within"]
			range = dic["within"].source
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
		if @range and eval(@range)
			@range = eval(@range)
			@min_value = @range.min
			@max_value = @range.max
			puts "RANGE: #{@range} #{min_value} #{max_value}"
		end
		if @max_value and @max_value != "nil" and @max_value.to_i
			@max_value = @max_value.to_i
		else
			@max_value = nil
		end
		if @min_value and @min_value != "nil" and @min_value.to_i
			@min_value = @min_value.to_i
		else
			@min_value = nil
		end
	end
	def is_child_same(old_constraint)
		if self.max_value == old_constraint.max_value and \
			self.min_value == old_constraint.min_value and \
			self.range == old_constraint.range and \
			self.is_constraint == old_constraint.is_constraint
			return true
		end
		return false
	end
	def is_same(old_constraint)
		if super and is_child_same(old_constraint)
			return true
		end
		return false
	end
	def is_same_notype(old_constraint)
		if super and is_child_same(old_constraint)
			return true
		end
		return false
	end

	def get_mismatch_fields(old_constraint)
		mismatch_fields = []
		if self.max_value != old_constraint.max_value
			mismatch_fields << "max_value"
		end
		if self.min_value != old_constraint.min_value
			mismatch_fields << "min_value"
		end
		if self.range != old_constraint.range
			mismatch_fields << "range"
		end
		if self.is_constraint != old_constraint.is_constraint
			mismatch_fields << "is_constraint"
		end

		return super + mismatch_fields
	end

	def self_print
		puts to_string
	end
	def to_string
		return "#{super} #{max_value} #{min_value} #{range} #{is_constraint}"
	end
end

class Format_constraint < Constraint
	attr_accessor :with_format, :on_condition
	def parse(dic)
		super
		if dic["with"]
			with_format = dic["with"].source
			self.with_format = with_format
		end
	end
	def is_child_same(old_constraint)
		if self.with_format == old_constraint.with_format and \
			self.on_condition == old_constraint.on_condition
			return true
		end
	end
	def is_same(old_constraint)
		return (super and is_child_same(old_constraint))
	end
	def is_same_notype(old_constraint)
		return (super and is_child_same(old_constraint))
	end
	def self_print
		puts to_string
	end
	def to_string
		return "#{super} #{with_format}"
	end

end

class Inclusion_constraint < Constraint
	attr_accessor :range
	def parse(dic)
		super
		if dic["in"]
			range = dic["in"].source
			self.range = range
		end
	end
	def is_child_same(old_constraint)
		if self.range == old_constraint.range
			return true
		end
		return false
	end
	def is_same(old_constraint)
		return (super and is_child_same(old_constraint))
	end
	def is_same_notype(old_constraint)
		return (super and is_child_same(old_constraint))
	end
	def self_print
		puts to_string
	end
	def to_string
		return "#{super} #{range}"
	end
end

class Exclusion_constraint < Constraint
	attr_accessor :range
	def parse(dic)
		super
		if dic["in"]
			range = dic["in"].source
			self.range = range
		end
	end
	def is_child_same(old_constraint)
		if self.range == old_constraint.range
			return true
		end
		return false
	end
	def is_same(old_constraint)
		return (super and is_child_same(old_constraint))
	end
	def is_same_notype(old_constraint)
		return (super and is_child_same(old_constraint))
	end
	def self_print
		puts to_string
	end
	def to_string
		return "#{super} #{range}"
	end
end

class Presence_constraint < Constraint

end

class Absence_constraint < Constraint

end

class Uniqueness_constraint < Constraint
	attr_accessor :scope, :case_sensitive
	def initialize(table, column, type, allow_nil=false, allow_blank=false)
		super(table, column, type, allow_nil=false, allow_blank=false)
		@case_sensitive = true
	end
	def parse(dic)
		super
		#@scope = []
		if dic["scope"]
			scope_ast = dic["scope"]
			if scope_ast.type.to_s == "symbol_literal"
				column = handle_symbol_literal_node(scope_ast)
				@scope = [column]
			end
			if scope_ast.type.to_s == "array"
				@scope = handle_array_node(scope_ast)
			end
		end
		if dic["case_sensitive"]&.source == "false"
			@case_sensitive = false
		end
	end
	def self_print
		puts to_string
	end
	def to_string
		return "#{super} #{scope}"
	end
	def is_child_same(old_constraint)
		return @scope == old_constraint.scope
	end
	def is_same(old_constraint)
		return (super and is_child_same(old_constraint))
	end
	def is_same_notype(old_constraint)
		return (super and is_child_same(old_constraint))
	end
	def get_mismatch_fields(old_constraint)
		mismatch_fields = []
		if @scope != old_constraint.scope
			mismatch_fields << "scope-#{@scope}-#{old_constraint.scope}"
		end

		return super + mismatch_fields
	end
end

class Numericality_constraint < Constraint
	attr_accessor :only_integer, :greater_than, :greater_than_or_equal_to, :equal_to, :less_than, :less_than_or_equal_to, :is_odd, :is_even
	def parse(dic)
		super
		if dic["only_integer"]&.source == "true"
			@only_integer = true
		end
		@greater_than = dic["greater_than"]&.source
		@greater_than_or_equal_to = dic["greater_than_or_equal_to"]&.source
		@equal_to = dic["equal_to"]&.source
		@less_than = dic["less_than"]&.source
		@less_than_or_equal_to = dic["less_than_or_equal_to"]&.source
		@is_odd = dic["odd"]&.source
		@is_even = dic["even"]&.source
	end
	def is_child_same(old_constraint)
		attributes = self.instance_variables.map{|x| x[2..-1]}
		if @only_integer == old_constraint.only_integer and \
		@greater_than == old_constraint.greater_than and \
		@greater_than_or_equal_to	== old_constraint.greater_than_or_equal_to and \
		@equal_to == old_constraint.equal_to and \
		@less_than == old_constraint.less_than and \
		@less_than_or_equal_to == old_constraint.less_than_or_equal_to and \
		@is_odd == old_constraint.is_odd	and \
		@is_even == old_constraint.is_odd
			return true
		end
		return false
	end
	def is_same(old_constraint)
		return (super and is_child_same(old_constraint))
	end
	def is_same_notype(old_constraint)
		return (super and is_child_same(old_constraint))
	end
	def get_mismatch_fields(old_constraint)
		mismatch_fields = []
		if @only_integer != old_constraint.only_integer
			mismatch_fields << "only_integer"
		end
		if @greater_than != old_constraint.greater_than
			mismatch_fields << "greater_than-#{@greater_than}-#{old_constraint.greater_than}"
		end
		if @greater_than_or_equal_to != old_constraint.greater_than_or_equal_to
			mismatch_fields << "greater_than_or_equal_to-#{@greater_than_or_equal_to}-#{old_constraint.greater_than_or_equal_to}"
		end
		if @equal_to != old_constraint.equal_to
			mismatch_fields << "equal_to-#{@equal_to}-#{old_constraint.equal_to}"
		end
		if @less_than != old_constraint.less_than
			mismatch_fields << "less_than-#{@less_than}-#{old_constraint.less_than}"
		end
		if @less_than_or_equal_to != old_constraint.less_than_or_equal_to
			mismatch_fields << "less_than_or_equal_to-#{@less_than_or_equal_to}-#{old_constraint.less_than_or_equal_to}"
		end
		if @is_odd != old_constraint.is_odd
			mismatch_fields << "is_odd-#{@is_odd}-#{old_constraint.is_odd}"
		end
		if @is_even != old_constraint.is_even
			mismatch_fields << "is_even-#{@is_even}-#{old_constraint.is_even}"
		end

		return super + mismatch_fields
	end
	def self_print
		puts to_string
	end
	def to_string
		return "#{super}"
	end
end
class Confirmation_constraint < Constraint
	attr_accessor :case_sensitive
	def initialize(table, column, type, allow_nil=false, allow_blank=false)
		super(table, column, type, allow_nil=false, allow_blank=false)
		@case_sensitive = true
	end
	def is_child_same(old_constraint)
		if old_constraint.case_sensitive == @case_sensitive
			return true
		end
		return false
	end
	def is_same(old_constraint)
		return (super and is_child_same(old_constraint))
	end
	def is_same_notype(old_constraint)
		return (super and is_child_same(old_constraint))
	end
	def parse(dic)
		super
		if  dic["case_sensitive"]&.source == "false"
			self.case_sensitive = false
		else
			self.case_sensitive = true
		end
		puts "self case case_sensitive #{self.case_sensitive}"
	end
	def self_print
		puts to_string
	end
	def to_string
		puts "#{super} #{self.case_sensitive}"
	end
end
class Acceptance_constraint < Constraint
	attr_accessor :accept_condition
	def parse(dic)
		return unless dic
		super
		@accept_condition = []
		if dic["accept"]
			accept_condition_ast = dic["accept"]
			puts "accept_condition_ast #{accept_condition_ast.type}"
			if accept_condition_ast.type.to_s == "symbol_literal"
				value = handle_symbol_literal_node(accept_condition_ast)
				@accept_condition << value
			end
			if accept_condition_ast.type.to_s == "string_literal"
				value = handle_string_literal_node(accept_condition_ast)
				@accept_condition << value
			end
			if accept_condition_ast.type.to_s == "array"
				@accept_condition = handle_array_node(accept_condition_ast)
			end
		end
	end
	def is_child_same(old_constraint)
		return self.accept_condition == old_constraint.accept_condition
	end
	def is_same(old_constraint)
		return (super and is_child_same(old_constraint))
	end
	def is_same_notype(old_constraint)
		return (super and is_child_same(old_constraint))
	end
end

class Function_constraint < Constraint
	attr_accessor :funcname
end

class Customized_constraint < Constraint

end

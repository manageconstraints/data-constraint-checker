class Class_class
	attr_accessor :filename, :class_name, :upper_class_name, :ast, :is_activerecord
	def initialize(filename)
		@filename = filename
		@is_activerecord = false
		@name = nil
		@upper_class_name = nil
		@ast = nil
		@constraints = {}
	end
	def add_constraints(constraints)
		constraints.each do |constraint|
			puts "constraint #{constraint.class}"
			key = "#{constraint.column}-#{constraint.class.name}"
			@constraints[key] = constraint
		end
		puts "@constraints.size #{@constraints.length}"
	end
	def getConstraints
		return @constraints
	end
end
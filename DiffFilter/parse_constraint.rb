require 'yard'
require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext/string'
def parse_model_constraint_file(ast)
	if ast.type.to_s == 'list'
		ast.children.each do |child|
			parse_model_constraint_file(child)
		end
	end
	if ast.type.to_s == 'class'
		c1 =  ast.children[0]
		c2 = ast.children[1] 
		if c1 and c1.type.to_s == 'const_ref'
			$cur_class.class_name = c1.source
		end
		if c2 and (c2.type.to_s == 'var_ref' or c2.type.to_s == 'const_path_ref')
			$cur_class.upper_class_name = c2.source
		end
		puts "filename: #{$cur_class.filename}"
		puts "classname: #{$cur_class.class_name} upper_class_name: #{$cur_class.upper_class_name}"
		c3 = ast.children[2]
		if c3
			parse_model_constraint_file(c3)
		end
	end
	if ast.type.to_s == "command"
		funcname = ast[0].source 
		if $validate_apis.include?funcname
			puts "funcname #{funcname}"
			parse_constraint_function(funcname, "model", ast)
		end
	end
end

def parse_db_constraint_file(ast)

end

def parse_constraint_function(funcname, type, ast)
  
end

def convert_tablename(name)
	_name = Array.new
	_word_list = Array.new
	name.split('').each do |c|
		if c == '_'
			_word_list.push(_name.join)
			_name = Array.new
		else
			_name.push(c)
		end
	end
	_word_list.push(_name.join)
	_word_list.each do |w|
		w[0] = w[0].capitalize
	end
	_word_list[-1] = _word_list[-1].singularize
	temp_name = _word_list.join
	return temp_name
end

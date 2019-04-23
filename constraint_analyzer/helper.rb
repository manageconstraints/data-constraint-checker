def load_validate_api
	$validate_apis = []
	validate_api = File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/validate_api")
	open(validate_api).readlines.each do |line|
		$validate_apis << line.strip
	end
	puts $validate_apis
end
def load_html_constraint_api
	$html_constraint_api = []
	input_field = File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/input_field")
	open(input_field).readlines.each do |line|
		$html_constraint_api << line.strip
	end
	#puts $html_constraint_api
end
def convert_tablename(name)
	return nil unless name
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
def derive_length_constraint_from_format(constraint)
	return nil unless constraint.is_a?Format_constraint
	format = constraint.with_format
  min_value, max_value = derive_length_from_format(format)
	len_constraint = Length_constraint.new(constraint.table, constraint.column, constraint.type)
  len_constraint.min_value = min_value
  len_constraint.max_value = max_value if max_value > 0
	return len_constraint
end

def derive_length_from_format(format)
  return nil unless format
  length = format.length
  index = 0
  min_value = 0
  max_value = 0
  prev = false
  while(true)
    if index >= length
      if prev
        min_value += 1
        max_value += 1 if max_value != -1

        #puts "add in last character #{min_value}"
      end
      break
    end
    c = format[index]
    if (not ["[", "{","+","*"].include?c)
      if prev
        min_value += 1
        max_value += 1 if max_value != -1
        #puts "add in normal character 1 #{min_value} c: #{c}"
      end
      prev = true
      index += 1
      next
    end
    if prev
      if c == "*"
        index += 1
        max_value = -1
        prev = false
        next
      elsif c == "+"
        index += 1
        min_value += 1
        max_value = -1
        prev = false
        next
      elsif c == "{"
        prev = false
        length_tmp = ""
        index += 1
        while(index < length and format[index] != "}")
          length_tmp += format[index]
          index += 1
          next
        end
        if length_tmp.include?(",")
          len_arr = length_tmp.split(",")
          min_value += len_arr[0].to_i
          if len_arr.length > 1 and len_arr[1].to_i != 0
            max_value += len_arr[1].to_i if max_value != -1
          else
            max_value = -1
          end
        else
          min_value += length_tmp.to_i
          max_value += length_tmp.to_i if max_value != -1
        end
        index += 1
        next
      elsif c != "["
        #puts "add in normal character #{min_value}"
        min_value += 1
        max_value += 1 if max_value != -1
        index += 1
        next
      end
    end
    if c == "["
      if prev
        min_value += 1
        max_value += 1 if max_value != -1
        #puts "add in [ #{min_value}"
      end
      index += 1
      while(index < length and format[index] != "]")
        index += 1
        next
      end
      prev = true
      index += 1
      next
    end
  end
  return min_value, max_value
end
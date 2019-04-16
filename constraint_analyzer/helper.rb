def load_validate_api
	$validate_apis = []
	open("validate_api").readlines.each do |line|
		$validate_apis << line.strip
	end
	puts $validate_apis
end
def load_html_constraint_api
	$html_constraint_api = []
	open("input_field").readlines.each do |line|
		$html_constraint_api << line.strip
	end
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
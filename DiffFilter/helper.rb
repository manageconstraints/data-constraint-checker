def load_validate_api
	$validate_apis = []
	open("validate_api").readlines.each do |line|
		$validate_apis << line.strip
	end
	puts $validate_apis
end
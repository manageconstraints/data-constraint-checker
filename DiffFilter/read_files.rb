require 'pathname'
def os_walk(dir)
  root = Pathname(dir)
  puts root
  files, dirs = [], []
  Pathname(root).find do |path|
    unless path == root
      dirs << path if path.directory?
      files << path if path.file?
    end
  end
  [root, files, dirs]
end
def read_ruby_files(application_dir=nil,version='')
	
	if application_dir and version
		$app_dir = application_dir
	else
		puts "application dir not defined or version number is not defined"
		return 
	end
	`cd #{$app_dir}; git checkout #{version}`

	root, files, dirs = os_walk($app_dir)
	model_classes = {}
	for filename in files
		filename = filename.to_s
		#puts "filename: #{filename}"
		contents = open(filename).read
		if filename.include?("app/models/")
			ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
			$cur_class = Class_class.new(filename)
			$cur_class.ast = ast
			#parse_model_constraint_file(ast)		
			model_classes[$cur_class.class_name] = $cur_class.dup	
		end
		if filename.include?("db/migrate/")
			ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
			$cur_class = Class_class.new(filename)
			$cur_class.ast = ast
			parse_db_constraint_file(ast)
		end
	end
	return model_classes
end

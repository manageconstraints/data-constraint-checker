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
	model_files = []
	migration_files = []
	for filename in files
		filename = filename.to_s
		#puts "filename: #{filename}"
		if filename.include?("app/models/")
			model_files << filename
		end
		if filename.include?("db/migrate/")
			migration_files  << filename
		end
	end
	model_files.each do |filename|
		contents = open(filename).read
		ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
		$cur_class = Class_class.new(filename)
		$cur_class.ast = ast
		parse_model_constraint_file(ast)		
		model_classes[$cur_class.class_name] = $cur_class.dup
		puts "\t\tAADD #{$cur_class.class_name} into model_classes #{$cur_class}"
	end
	$model_classes = model_classes
	puts "********migration_files:********"
	puts migration_files
	migration_files.each do |filename|
		contents = open(filename).read
		ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
		$cur_class = Class_class.new(filename)
		$cur_class.ast = ast
		parse_db_constraint_file(ast)
	end
	return model_classes
end

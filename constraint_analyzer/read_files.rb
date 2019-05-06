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
	# checkout to specified version
	if version != ''
		`cd #{$app_dir};git stash; git checkout #{version}`
	end

  puts "$application_dir #{$app_dir}"
	root, files, dirs = os_walk($app_dir)
	model_classes = {}
	model_files = []
	migration_files = []
	view_files = []
	for filename in files
		filename = filename.to_s
		if filename.include?("app/models/")
			model_files << filename
		end
		if filename.include?("db/migrate/")
			migration_files  << filename
    end
    if filename.include?("db/schema.rb")
      migration_files = [filename]
    end
		if filename.include?("app/views/")
			view_files << filename
		end
	end
	model_files.each do |filename|
    file = open(filename)
    contents = file.read
    file.close
		begin 
			ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
			$cur_class = Class_class.new(filename)
			$cur_class.ast = ast
			parse_model_constraint_file(ast)		
			model_classes[$cur_class.class_name] = $cur_class.dup
			puts "add new class #{$cur_class.class_name} #{$cur_class.upper_class_name}"
    rescue
      puts "filename: #{filename}"
		end
	end
	puts "finished handle model files #{model_files.length} #{model_classes.length}"
	$model_classes = model_classes
	$dangling_classes = {}
	puts "********migration_files:********"
	puts migration_files
	cnt = 0
	migration_files.each do |filename|
    file = open(filename)
		contents = file.read
    file.close
		begin
			ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
			$cur_class = Class_class.new(filename)
			$cur_class.ast = ast
			parse_db_constraint_file(ast)
			cnt += 1
		rescue
		end
	end
	puts "finished handle migration files #{migration_files.length} #{cnt}"

	read_html_file_ast(view_files)

	return model_classes
end

def read_html_file_ast(view_files)
	view_files.each do |filename|
    #puts "filenmae: #{filename}"
		erb_filename = filename
		haml2html = File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/herbalizer")
		os = `uname -a`
		if os.include?"Linux"
			haml2html = "python3 #{File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/haml2html.py")}"
		end
		extract_erb = File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/extract_rubynhtml.rb")
    base = filename.gsub("/","_").gsub(".", "")
    if filename.include?"haml"
			formalize_script = File.join(File.expand_path(File.dirname(__FILE__)), "../constraint_analyzer/formalize_haml.rb")
      formalized_filename = File.join(File.expand_path(File.dirname(__FILE__)), "../tmp/#{base}1.html.erb")
			erb_filename = File.join(File.expand_path(File.dirname(__FILE__)), "../tmp/#{base}2.html.erb")
			`ruby #{formalize_script} #{filename}  #{formalized_filename};`
			#puts "formalized_filename #{open(formalized_filename).read}"
			#puts "#{haml2html} #{formalized_filename} > #{erb_filename}"
			`#{haml2html} #{formalized_filename} > #{erb_filename}`
			#puts "contents #{open(erb_filename).read}"
      `rm #{formalized_filename}`
		end
		target = File.join(File.expand_path(File.dirname(__FILE__)), "../tmp/#{base}.rb")
		`ruby #{extract_erb} #{erb_filename} #{target}`
		file = open(target)
		contents = file.read
    if not (contents.include?"required" or contents.include?"maxlength" or contents.include?"minlength" or contents.include?"pattern")
      next
    end
		file.close
		if erb_filename.include?"haml"
    	`rm #{erb_filename}` 
    end
    `rm #{target}`
		begin
			ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
			$cur_class = Class_class.new(filename)
      puts "$cur_class #{$cur_class.filename}"
			parse_html_constraint_file(ast)
		rescue
		end
	end
end

require 'pathname'
require 'yard'
require 'pp'

def check_all_apps()
  # %w(discourse
  # lobsters
  # gitlabhq
  # redmine
  # spree
  # ror_ecommerce
  # fulcrum
  # tracks
  # onebody
  # diaspora
  # falling-fruit
  # openstreetmap-website).each do |app_name|
  #   check_custom_validations_for_error "/Users/utsavsethi/workspace/apps/" + app_name
  # end
  check_custom_validations_for_error "/Users/utsavsethi/workspace/apps/tracks"

end

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

def check_custom_validations_for_error(application_dir=nil)
  unless application_dir
    puts "application dir not defined"
    return
  end

  root, files, dirs = os_walk(application_dir)
  model_files = []
  for filename in files
    filename = filename.to_s
    if filename.include?("app/models/")
      model_files << filename
    end
  end

  model_files.each do |filename|
    file = open(filename)
    contents = file.read
    file.close
    begin
      ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
      parse_model_file_for_errors(ast)
    rescue StandardError => e
      puts "failed filename: #{filename}"
      puts e.message
    end
  end
end

def parse_model_file_for_errors(ast)
  if ast.type.to_s == 'list'
    ast.children.each do |child|
      parse_model_file_for_errors(child)
    end
  end
  if ast.type.to_s == 'module'
    if ast[1] and ast[1].type.to_s == "list"
      ast[1].each do |child|
        parse_model_file_for_errors(child)
      end
    end
  end
  if ast.type.to_s == 'class'
    c1 =  ast.children[0]
    c2 = ast.children[1]
    if c1 and c1.type.to_s == 'const_ref'
      #puts "class #{c1.source}"
    end
    if c2 and (c2.type.to_s == 'var_ref' or c2.type.to_s == 'const_path_ref')
      #puts "c2.source #{c2.source}"
    end
    # puts"filename: #{$cur_class.filename} "
    # puts"classname: #{$cur_class.class_name} upper_class_name: #{$cur_class.upper_class_name}"
    c3 = ast.children[2]
    if c3
      parse_model_file_for_errors(c3)
    end
  end
  if ast.type.to_s == "command"
    funcname = ast[0].source
    if %w(validate validates_each validate_with).include?funcname
      #puts"funcname #{funcname} #{ast.source}"
      check_validation_function(funcname, ast)
    end
  end
  if ast.type.to_s == "fcall"
    funcname = ast[0].source
    if %w(validate validates_each validate_with).include?funcname
      #puts"funcname #{funcname} #{ast.source}"
      check_validation_function(funcname, ast)
    end
  end

end

def check_validation_function(funcname, ast)
  if ast.source.include? "errors.add"
    puts "Found error message"
  else
    puts ast.source
    puts "Did not find!"
  end

end


check_all_apps
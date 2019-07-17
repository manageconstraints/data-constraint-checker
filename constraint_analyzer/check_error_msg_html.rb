require 'pathname'
require 'yard'
require 'pp'

def check_all_apps(app_dir)
  $error_results = {}
  [
  "discourse",
  "lobsters",
  "gitlabhq",
  "redmine",
  "spree",
  "ror_ecommerce",
  "fulcrum",
  "tracks",
  "onebody",
  "diaspora",
  "falling-fruit",
  "openstreetmap-website"
  ].each do |app_name|
    check_app_for_missing_html_errors(app_dir + app_name, app_name)
  end
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



def check_app_for_missing_html_errors(application_dir=nil, app_name)

  unless application_dir
    puts "application dir not defined"
    return
  end

  # $cur_app = app_name
  #
  # $error_results[app_name] = {}
  # $error_results[app_name][:missing] = {}
  # $error_results[app_name][:found] = {}

  root, files, dirs = os_walk(application_dir)
  view_files = []
  for filename in files
    filename = filename.to_s
    if filename.include?("app/views/")
      view_files << filename
    end
  end

  #view_files = ["/Users/utsavsethi/workspace/apps/falling-fruit/app/models/observation.rb"]
  view_files.each do |filename|
    #puts "filename: #{filename}"
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
    if contents.include?"form_for"
      unless ["errors", "devise_error_messages!", "form_errors", "error_messages", "error_message_on", "error_messages_for", "@errors", "partial"]
             .reduce(false) do |result, str|
          result = result || contents.include?(str)
      end
        puts filename
      end
    end

    file.close
    if erb_filename.include?"haml"
      `rm #{erb_filename}`
    end
    `rm #{target}`
    # begin
    #   ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
    #   $cur_class = File_class.new(filename)
    #   puts "$cur_class #{$cur_class.filename}"
    #   parse_html_constraint_file(ast)
    # rescue
    # end
  end
end

check_all_apps("/Users/utsavsethi/workspace/apps/")
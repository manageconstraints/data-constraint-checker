require 'pathname'
require 'yard'
require 'pp'

$error_results

def check_all_apps(app_dir)
  $error_results = {}
  %w(discourse
  lobsters
  gitlabhq
  redmine
  spree
  ror_ecommerce
  fulcrum
  tracks
  onebody
  diaspora
  falling-fruit
  openstreetmap-website).each do |app_name|
    check_app_for_missing_errors(app_dir + app_name, app_name)
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



def get_validation_function_names(ast)
  if ast.type.to_s == 'list'
    ast.children.each do |child|
      get_validation_function_names(child)
    end
  end
  if ast.type.to_s == 'module'
    if ast[1] and ast[1].type.to_s == "list"
      ast[1].each do |child|
        get_validation_function_names(child)
      end
    end
  end
  if ast.type.to_s == 'class'
    c1 =  ast.children[0] # Class name
    c2 = ast.children[1] # Parent class name
    c3 = ast.children[2] # Class definition
    if c3
      get_validation_function_names(c3)
    end
  end
  if ast.type.to_s == "command"
    funcname = ast[0].source
    if %w(validate validates_each validate_with).include?funcname
      if ast[1].type == :list
        ast[1].each do |name|
          if name
            $func_name_acc << name[0][0][0]
          end
        end
      end
    end
  end
end

def found_missing(app_name, file, source)
  if $error_results[app_name][:missing][file]
    $error_results[app_name][:missing][file] << source
  else
    $error_results[app_name][:missing][file] =  [source]
  end
end

def did_not_find(app_name, file, source)
  if $error_results[app_name][:found][file]
    $error_results[app_name][:found][file] << source
  else
    $error_results[app_name][:found][file] = [source]
  end
end

def check_for_error(ast, funcnames)
  if ast.type.to_s == 'list'
    ast.children.each do |child|
      check_for_error(child, funcnames)
    end
  end
  if ast.type.to_s == 'module'
    if ast[1] and ast[1].type.to_s == "list"
      ast[1].each do |child|
        check_for_error(child, funcnames)
      end
    end
  end
  if ast.type.to_s == 'class'
    c1 =  ast.children[0] # Class name
    c2 = ast.children[1] # Parent class name
    c3 = ast.children[2] # Class definition
    if c3
      check_for_error(c3, funcnames)
    end
  end
  if ast.type.to_s == "fcall"
    funcname = ast[0].source
    if %w(validate).include?funcname
      if ast[2] and ast[2].type.to_s == "do_block"
        if !(ast[2].source.include? "errors.add" or ast[2].source.include? "errors[")
          found_missing($cur_app, $cur_file, ast.source)
          # puts $cur_file
          # puts "Missing error!"
          # puts ast.source
        else
          did_not_find($cur_app, $cur_file, ast.source)
          # puts $cur_file
          # puts "Error check - OK"
        end
      end
    end
  end
  if ast.type.to_s == "command"
    funcname = ast[0].source
    if %w(validate validates_each).include?funcname
      if ast[2] and ast[2].type.to_s == "do_block"
        if !(ast[2].source.include? "errors.add" or ast[2].source.include? "errors[")
          found_missing($cur_app, $cur_file, ast.source)
          # puts $cur_file
          # puts "Missing error!"
          # puts ast.source
        else
          did_not_find($cur_app, $cur_file, ast.source)
          # puts $cur_file
          # puts "Error check - OK"
        end
      end
    end
  end
  if ast.type.to_s == "def" and funcnames.include? ast[0].source
    if !(ast.source.include? "errors.add" or ast.source.include? "errors[")
      found_missing($cur_app, $cur_file, ast.source)
      # puts $cur_file
      # puts "Missing error!"
      # puts ast.source
    else
      did_not_find($cur_app, $cur_file, ast.source)
      # puts $cur_file
      # puts "Error check - OK"
    end
  end
end

def summarize_results()
  $error_results.each do |appname, results|
    num_found = results[:found].reduce(0) {|sum, (key, value)| sum += value.size}
    num_missing = results[:missing].reduce(0) {|sum, (key, value)| sum += value.size}

    puts appname + "\tnum_found: " + num_found.to_s + "\tnum_missing: " + num_missing.to_s
  end
end

def search_ast_for_missing_errors(ast)
  $func_name_acc = []
  get_validation_function_names(ast)
  funcnames = $func_name_acc.clone
  check_for_error(ast, funcnames)

end


# grep -ril "EachValidator" * | xargs -I % grep -iL "errors\.add\|errors\[" %


check_all_apps "/Users/utsavsethi/workspace/apps/"
pp $error_results
summarize_results

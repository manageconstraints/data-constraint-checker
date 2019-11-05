def parse_html_constraint_file(ast)
  #puts "ast.type.to_s #{ast.type.to_s}"
  table = ""
  if ast.type.to_s == "list"
    ast.children.each do |child|
      #puts "child.type.to_s #{child.type.to_s}"
      parse_html_constraint_file(child)
    end
  end
  if ast.type.to_s == "fcall"
    funcname = ast[0].source
    if $html_constraint_api.include? funcname
      parse_html_constraint_function(table, funcname, ast)
    end
    ast.children.each do |child|
      parse_html_constraint_file(child)
    end
  end
  if ast.type.to_s == "command"
    funcname = ast[0].source
    if $html_constraint_api.include? funcname
      parse_html_constraint_function(table, funcname, ast)
    end
    ast.children.each do |child|
      parse_html_constraint_file(child)
    end
  end
  if ast.type.to_s == "command_call"
    funcname = ast[2]&.source
    if $html_constraint_api.include? funcname and ast[3]&.type.to_s == "list"
      parse_html_constraint_function(table, funcname, ast)
    end
  end
  if ast.type.to_s == "do_block"
    ast.children.each do |child|
      if child.type.to_s == "list"
        child.children.each do |c|
          parse_html_constraint_file(c)
        end
      end
    end
  end
end

def parse_html_constraint_function(table, funcname, ast)
  #puts "parse_html_constraint_function #{funcname}"
  if ast.type.to_s == "command_call"
    param_ast = ast[3]
  else
    param_ast = ast[1]
    param_ast = ast[1][0] if ast[1].type.to_s == "arg_paren"
  end
  symbols = []
  dic = {}

  param_ast.children.each do |child|
    #puts "child #{child.type.to_s} #{child.source}"
    if child.type.to_s == "string_literal"
      symbol = handle_string_literal_node(child)
      symbols << symbol
    end
    if child.type.to_s == "symbol_literal"
      symbol = handle_symbol_literal_node(child)
      symbols << symbol
    end
    if child.type.to_s == "list"
      dic = extract_hash_from_list(child)
    end
  end
  if field = symbols[0][/\[.*\]/]
    table = symbols[0].split("[")[0]
    column = field.gsub("[", "").gsub("]", "")
  else
    table = $cur_class.filename.split("/")[-2]
    column = symbols[0]
  end
  if symbols.length == 2
    table = symbols[0]
    column = symbols[1]
  end

  if ["registrations", "sessions", "accounts"].include? table
    table = "users"
    if $app_dir2 and $app_dir2.include? "onebody"
      table = "people"
    end
  end
  #puts "table: #{table}"
  dic2 = {}
  dic2["maximum"] = dic["maxlength"] if dic["maxlength"]
  dic2["minimum"] = dic["minlength"] if dic["minlength"]
  class_name = convert_tablename(table)
  #puts "class_name: #{class_name}"
  table_class = $model_classes[class_name]
  #puts "#{table_class == nil} | #{dic2.length} #{column}"
  if table_class
    if dic2.length > 0
      constraint = Length_constraint.new(class_name, column, Constraint::HTML)
      constraint.parse(dic2)
      table_class.addConstraints([constraint])
      # puts "Add html Constraint: #{constraint.to_string}"
    end
    if dic["pattern"]
      #puts "dic[pattern] = #{dic["pattern"].source}"
      constraint = Format_constraint.new(class_name, column, Constraint::HTML)
      format = handle_string_literal_node(dic["pattern"]) || handle_symbol_literal_node(dic["pattern"])
      constraint.with_format = format
      table_class.addConstraints([constraint])
      # puts "Add html Constraint: #{constraint.to_string}"
    end
    if dic["required"]
      constraint = Presence_constraint.new(class_name, column, Constraint::HTML)
      table_class.addConstraints([constraint])
      # puts "Add html Constraint: #{constraint.to_string}"
    end
  end
end

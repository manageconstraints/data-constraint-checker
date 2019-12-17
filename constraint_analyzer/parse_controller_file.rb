def parse_controller_file(ast)
  if ast.type.to_s == "list"
    ast.children.each do |child|
      parse_controller_file(child)
    end
  end
  if ast.type.to_s == "module"
    moduleName = ast[0]&.source
    if ast[1] and ast[1].type.to_s == "list"
      ast[1].each do |child|
        parse_controller_file(child)
      end
    end
  end
  if ast.type.to_s == "class"
    c1 = ast.children[0]
    c2 = ast.children[1]
    c3 = ast.children[2]
    if c3
      parse_controller_file(c3)
    end
  end
  if ast.type.to_s == "def"
    funcname = ast[0].source
    #if ['update', 'edit'].include?funcname
    code = ast.source
    rescue_keyword = "rescue"
    update_keyword = "update"
    save_keyword = "save"
    if code.include? update_keyword or code.include? save_keyword
      $write_action_num += 1
      if $global_resuce
        return
      end
      if not code.include? rescue_keyword
        $code = ast.source
        $no_resuce_num += 1
      end
    end
    ast.children.each do |child|
      parse_controller_file(child)
    end
  end
  if ["if", "unless"].include?ast.type.to_s
    $if_output.write("===========================\n")
    $if_output.write($fn + "\n")
    $if_output.write(ast.source + "\n")  
  end
end

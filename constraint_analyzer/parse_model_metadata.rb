def parse_model_var_refs(ast, acc)
  if ast.respond_to? "type" and ast.type.to_s == "call" \
    and ast[0].respond_to? "type" and ast[0].type.to_s == "var_ref" \
    and ast[0][0].source == "self" and ast[1].to_s == "."
    acc << ast[2].source.gsub("?", "")
  elsif ast.respond_to? "type" and ast.type.to_s == "assign" \
    and ast[0].respond_to? "type" and ast[0].type.to_s == "field" \
    and ast[0][0].respond_to? "type" and ast[0][0].type == "var_ref" \
    and ast[0][0][0].source == "self" \
    and ast[1].to_s == "."
    acc << ast[2].source
  elsif ast.respond_to? "children"
    ast.children.each do |child|
      parse_model_var_refs(child, acc)
    end
  end
end

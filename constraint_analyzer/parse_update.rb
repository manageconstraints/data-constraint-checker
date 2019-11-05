require "yard"

def parse_update_all(ast)
  if ast.type == "call" and ast.source.include?("update_all")
  end
end

def parse_update_columns(ast)
end

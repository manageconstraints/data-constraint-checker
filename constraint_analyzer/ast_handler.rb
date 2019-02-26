def handle_hash_node(node)
	dic = {}
	node.children.each do |child|
		if child.type.to_s == "assoc"
			key, value = handle_assoc_node(child)
			if key and value
				dic[key] = value
			end
		end
	end
	return dic
end
def handle_assoc_node(child)
	key = nil
	value = nil
	if child[0].type.to_s == "symbol_literal"
		key = handle_symbol_literal_node(child[0])
	end
	if child[0].type.to_s == "label"
		key = handle_label_node(child[0])
	end
	value = child[1]
	## puts"key: #{key} value: #{value.source}"
	return key,value
end 

def handle_symbol_literal_node(symbol)
	return symbol[0][0].source
end

def handle_label_node(label)
	return label[0]
end

def handle_array_node(ast)
	scope = []
	if ast.type.to_s == "array"
		if ast[0].type.to_s == "list"
			ast[0].each do |child|
				if child.type.to_s == "symbol_literal"
					column = handle_symbol_literal_node(child)
					scope << column
				end
			end
		end
		return scope
	end
	return nil
end
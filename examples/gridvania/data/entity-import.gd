extends LDTKEntityMapperScript

func import(node: Node, data: Dictionary) -> Node:
	match node.name:
		"LightTest":
			node.color = data.smart_color
	return node

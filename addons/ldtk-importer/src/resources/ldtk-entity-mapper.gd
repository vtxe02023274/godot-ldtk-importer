@tool
class_name LDTKEntityMapper
extends Resource

@export var entities: Dictionary[String,PackedScene] = {}
@export var import_script: GDScript

var import: GDScript

func create_instance(data: Dictionary) -> Node:
	var id: String = data.identifier
	if entities.has(id) and entities[id]:
		var node: Node = entities[id].instantiate()
		if node:
			node.name = id
			node.position = data.position
			if node is Node2D:
				node.modulate = data.smart_color

			if import_script:
				if not import: import = import_script.new()
				node = import.import(node, data)

			return node
	return null

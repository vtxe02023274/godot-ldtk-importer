@tool
class_name LDTKReference extends Resource

@export var iid: String
@export var sceneFile: String ## Scene File
@export var scenePath: NodePath ## Scene Path

var node: Node  		# Expected: Node, but needs to accept null
var __nodePath: NodePath

func _init(_iid: String = "", _node: Node = null) -> void:
	iid = _iid
	node = _node

func load_node_path() -> Node:
	return LDTK.load_reference(self)

func get_node_path(start_node: Node = LDTK) -> NodePath:
	if start_node.owner.scene_file_path == sceneFile:
		var _node: Node = start_node.owner.get_node(scenePath)
		if _node:
			return start_node.get_path_to(_node)

	if not node: return ^""
	var path := start_node.get_path_to(node)

	if start_node == LDTK:
		__nodePath = path
	return path


@tool
extends Node

## LDTK AUTOLOAD

## References
var references := {}

func _ready() -> void:
	references.clear()

func get_reference(iid: String) -> LDTKReference:
	if references.has(iid):
		return references[iid]
	return null

func load_reference(ref: LDTKReference) -> Node:
	var scene: PackedScene = load(ref.sceneFile)
	if not scene: return null

	var node = scene.instantiate()
	if not node: return null

	return node

func register_reference(iid: String, node: Node) -> void:
	var ref := get_reference(iid)
	if not ref:
		ref = LDTKReference.new(iid, node)
	ref.node = node
	if node.owner:
		ref.sceneFile = node.owner.scene_file_path
		ref.scenePath = node.owner.get_path_to(node)
	elif node.scene_file_path:
		ref.sceneFile = node.scene_file_path
		ref.scenePath = ^""
	else:
		push_error("Error occurred")
	references[iid] = ref

func unregister_reference(iid: String, node: Node) -> void:
	var ref := get_reference(iid)
	if ref:
		ref.node = null

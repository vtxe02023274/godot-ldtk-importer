@tool
extends Node

## LDTK AUTOLOAD

## Dictionary of LDTK `iids` that correspond to a `LDTKReference`, which can store a node path
## and a full scene path for any given reference.
var references := {}

func _ready() -> void:
	references.clear()

## Return LDTKReference if stored, otherwise return null.
func get_reference(iid: String) -> LDTKReference:
	if references.has(iid):
		return references[iid]
	return null

## Load and return the scene that this reference belongs to (typically an LDTKLevel)
func load_reference(ref: LDTKReference, use_cache := true) -> Node:
	if use_cache:
		var cache_ref := get_reference(ref.iid)
		if cache_ref and cache_ref.node:
				return cache_ref.node

	var scene: PackedScene = load(ref.sceneFile)
	if not scene: return null

	var node = scene.instantiate()
	if not node: return null

	return node

## Store the node the reference belongs to, for later lookup by other LDTKReferences.
## Best done when node has entered the SceneTree (e.g. _ready())
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

## Remove the stored node on the matching reference, making it null.
## Best done when node has exited the SceneTree (e.g. _exit_tree())
func unregister_reference(iid: String, node: Node) -> void:
	var ref := get_reference(iid)
	if ref:
		ref.node = null

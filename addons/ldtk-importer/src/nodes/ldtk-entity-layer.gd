@tool
@icon("ldtk-entity-layer.svg")
class_name LDTKEntityLayer
extends Node2D

@export var iid: String
@export var definition: Dictionary
@export var entities: Array
@export var entity_definitions: Dictionary

func _enter_tree() -> void:
	LDTK.register_reference(iid, self)

func _exit_tree() -> void:
	LDTK.unregister_reference(iid, self)

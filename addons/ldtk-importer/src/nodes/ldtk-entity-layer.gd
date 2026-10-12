@tool
@icon("ldtk-entity-layer.svg")
class_name LDTKEntityLayer
extends Node2D

## Unique Instance ID, provided by LDTK.
@export var iid: String
## Parsed EntityLayer definition.
@export var definition: Dictionary
## List of entity instances on this EntityLayer.
@export var entities: Array
## Dictionary containing definitions for each unique Entity on this layer.
@export var entity_definitions: Dictionary

func _enter_tree() -> void:
	LDTK.register_reference(iid, self)

func _exit_tree() -> void:
	LDTK.unregister_reference(iid, self)

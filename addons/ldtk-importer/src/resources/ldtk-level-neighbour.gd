class_name LDTKLevelNeighbour
extends Resource

@export var dir: LDTKLevel.NEIGHBOUR
@export var level: LDTKReference

func _init(_level: LDTKReference = null) -> void:
	level = _level

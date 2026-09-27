@icon("ldtk-level.svg")
@tool
class_name LDTKLevel
extends Node2D

@export var iid: String
@export var world_position: Vector2
@export var size: Vector2i
@export var fields: Dictionary
@export var neighbours: Array[LDTKLevelNeighbour]
@export var bg_color: Color

enum NEIGHBOUR {NORTH, SOUTH, EAST, WEST, NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST, UPPER, LOWER, OVERLAP, UNKNOWN}

func _exit_tree() -> void:
	LDTK.unregister_reference(iid, self)

func _ready() -> void:
	LDTK.register_reference(iid, self)
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("load_neighbours"):
		load_neighbours()

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2(Vector2.ZERO, size), bg_color, false, 2.0)

func load_neighbours() -> void:
	for neighbour in neighbours:
		var level: LDTKLevel = LDTK.load_reference(neighbour.iid)
		if level:
			add_sibling(level)

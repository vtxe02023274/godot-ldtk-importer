@icon("ldtk-level.svg")
@tool
class_name LDTKLevel
extends Node2D

## Unique Instance ID, provided by LDTK.
@export var iid: String
## Level's position on the world map, in pixels.
@export var world_position: Vector2i
## Level's size, in pixels.
@export var size: Vector2i
## Custom data fields stored on this level.
@export var fields: Dictionary
## List of LDTKLevelNeighbours, containing a reference to the LDTKLevel scene as well as its placement.
@export var neighbours: Array[LDTKLevelNeighbour]
## Background color for this room.
@export var bg_color: Color

enum NEIGHBOUR {
	NORTH, 		## Neighbour is directly [b]above[/b] this level.
	SOUTH,		## Neighbour is directly [b]below[/b] this level.
	EAST,		## Neighbour is directly [b]right[/b] of this level.
	WEST, 		## Neighbour is directly [b]left[/b] of this level.
	NORTHWEST,	## Neighbour is [b]above[/b] and to the [b]left[/b] of this level.
	NORTHEAST, 	## Neighbour is [b]above[/b] and to the [b]right[/b] of this level.
	SOUTHWEST, 	## Neighbour is [b]below[/b] and to the [b]left[/b] of this level.
	SOUTHEAST,	## Neighbour is [b]below[/b] and to the [b]right[/b] of this level.
	UPPER, 		## Neighbour is [b]overlapping[/b] but on a [b]higher WorldLayer[/b] to this level.
	LOWER, 		## Neighbour is [b]overlapping[/b] but on a [b]lower WorldLayer[/b] to this level.
	OVERLAP, 	## Neighbour is [b]overlapping[/b] with this level.
	UNKNOWN 	## Unknown relationship. Used as a fallback.
}

func _exit_tree() -> void:
	LDTK.unregister_reference(iid, self)

func _ready() -> void:
	LDTK.register_reference(iid, self)
	queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2(Vector2.ZERO, size), bg_color, false, 2.0)

## Load all neighbour LDTKLevels into the SceneTree as siblings.
func load_neighbours() -> void:
	for neighbour: LDTKLevelNeighbour in neighbours:
		var level: LDTKLevel = LDTK.load_reference(neighbour.level)
		level.global_position = level.world_position
		if level:
			add_sibling(level, true)

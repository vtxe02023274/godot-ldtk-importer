## Placeholder Node for importing LDTK maps.
## Used to demonstrate import functionality - please write an Entity Post-Import script to spawn
## your own instances when using this in your project.
@icon("ldtk-entity.svg")
@tool
class_name LDTKEntity
extends Node2D

## Identifier String. [br]
## [b]NOTE[/b]: Does not always match [code]Node.name[/code] if multiple instances are present.
@export var identifier := "EntityPlaceholder"
## Unique Instance ID, provided by LDTK.
@export var iid: String
## Definition UID for this Entity. Can be used to reference the Entity Definition in `LDTKEntityLayer.entity_definitions`.
@export var defUid: int
## Smart Color derived from Entity data.
@export var smart_color := Color.hex(0xffcc0088)
## Entity size, in pixels.
@export var pxSize := Vector2.ZERO
## Dictionary containing parsed field entries for this Entity instance.
@export var fields := {}

#@export var pivot := Vector2.ZERO
#@export var definition := {}

@onready var sprite: Sprite2D = $Sprite
@onready var label: Label = $Label

var definition: Dictionary
var _refs := []
var _points := []
var _drawPaths := false
var _tex: Texture2D

func _exit_tree() -> void:
	LDTK.unregister_reference(iid, self)

func _ready() -> void:
	LDTK.register_reference(iid, self)
	_recalculate()

func _input(event: InputEvent) -> void:
	if event.is_action("debug"):
		_recalculate()

func _recalculate() -> void:
	_points.clear()
	_points.append(Vector2.ZERO)
	for key in fields:
		var value: Variant = fields[key]
		if value is String:
			if not label.text:
				label.text = value
		if value is NodePath:
			_refs.append(value)
		elif value is LDTKReference:
			_refs.append(value)
		elif value is Vector2i:
			_points.append(value)
		elif value is Array:
			for value2 in value:
				if value2 is NodePath:
					_refs.append(value2)
				elif value2 is Vector2i:
					_points.append(value2)
				else:
					break
		elif value is Texture2D:
			_tex = value
	_drawPaths = _refs.size() > 0 or _points.size() > 0
	_points = _parse_points(_points)
	queue_redraw()

func _draw() -> void:
	if not definition:
		definition = _get_definition()

	if definition.is_empty(): return

	var pivot = Vector2(0.5, 0.5)

	if definition.has("pivot"):
		pivot = definition.pivot

	match definition.renderMode:
		"Ellipse":
			if definition.hollow:
				draw_arc((pxSize * 0.5) + pxSize * -pivot, pxSize.x * 0.5, 0, TAU, 24, smart_color, 1.0)
			else:
				draw_circle((pxSize * 0.5) + pxSize * -pivot, pxSize.x * 0.5, smart_color)
		"Rectangle":
			if definition.hollow:
				draw_rect(Rect2(pxSize * -pivot, pxSize), smart_color, false, 1.0)
			else:
				draw_rect(Rect2(pxSize * -pivot, pxSize), smart_color, true)
		"Cross":
			draw_line(Vector2.ZERO, pxSize, smart_color, 3.0)
			draw_line(Vector2(0, pxSize.y), Vector2(pxSize.x, 0), smart_color, 3.0)
		"Tile":
			if definition.tile == null:
				pass
			if definition.tile is Texture2D:
				sprite.texture = definition.tile

	if _drawPaths:
		for ref in _refs:
			if ref is LDTKReference:
				var lookup: LDTKReference = LDTK.get_reference(ref.iid)
				if not lookup: continue
				var node
				var path = lookup.get_node_path(self)
				if path:
					node = get_node(path)
					if not node:
						node = lookup.node
				if node:
					draw_dashed_line(Vector2.ZERO, node.global_position - global_position, Color.ORANGE_RED, 4.0, 8.0)
				else:
					#print("Can't get: %s | %s %s" % [ref.node, ref.sceneFile, ref.scenePath])
					pass

				continue
			elif ref is not NodePath:
				continue
			elif ref.is_empty():
				continue
			var node = get_node(ref)
			if node:
				draw_dashed_line(Vector2.ZERO, node.global_position - global_position, smart_color)

		var previousPoint = _points[0]
		for point in _points:
			if point == previousPoint:
				continue
			draw_dashed_line(Vector2(previousPoint), Vector2(point), smart_color, 1.0, 4.0)
			draw_arc(point, 4.0, 0, TAU, 5, smart_color, 1.0)
			previousPoint = point

	if _tex:
		var _size = _tex.get_size()
		draw_texture(_tex, -_size/2)


func _parse_points(points: Array) -> Array:
	if points.size() == 0: return points
	if get_parent() is SubViewport: return points

	var origin = get_parent().global_position - global_position
	var gridSize = get_parent().definition.gridSize
	var cellOffset = gridSize * Vector2(0.5, 0.5)
	for index in range(1, points.size()):
		var pixelCoord = points[index] * gridSize
		points[index] = origin + pixelCoord + cellOffset
	return points

func _get_definition() -> Dictionary:
	var parent = get_parent() as LDTKEntityLayer
	if not parent:
		return {}
	if parent.entity_definitions.has(defUid):
		return parent.entity_definitions[defUid]
	else:
		return {}

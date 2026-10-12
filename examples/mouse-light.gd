extends PointLight2D

@onready var world: LDTKWorld = $"../example_gridvania"
@onready var camera: Camera2D = $"../Camera2D"
var dragging: bool = false

func _ready() -> void:
	await owner.ready
	camera.position = world.rect.size / 2 - DisplayServer.window_get_size() / 2

func _input(event: InputEvent) -> void:
	if event.is_action("drag"):
		dragging = event.is_pressed()
	elif event is InputEventMouseMotion:
		global_position = get_global_mouse_position()
		if dragging:
			@warning_ignore("unsafe_property_access")
			camera.offset -= event.relative

	if event.is_action_pressed("debug"):
		print("--- LDTK REFS ---")
		for ref: LDTKReference in LDTK.references.values():
			print(ref.node)
		print("-----------------")

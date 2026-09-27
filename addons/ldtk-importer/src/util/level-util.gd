@tool

const Util = preload("util.gd")

static func get_external_level(
		level_data: Dictionary,
		base_dir: String
) -> Dictionary:

	var level_file: String = base_dir + level_data.externalRelPath
	var new_level_data: Dictionary = Util.parse_file(level_file)
	if new_level_data == null:
		push_warning("Could not parse external level: ", level_file)
		return level_data
	else:
		return new_level_data

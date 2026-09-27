@tool

# When building definitions we are only collecting data we need and do some pre-parsing to make the next steps easier.

static func build_definitions(world_data: Dictionary) -> Dictionary:
	var definitions := {
		"enums": _parse_enum_definitions(world_data.defs.enums),
		"entities": _parse_entity_definitions(world_data.defs.entities),
		"layers": _parse_layer_definitions(world_data.defs.layers),
		"tilesets": _parse_tileset_definitions(world_data.defs.tilesets, world_data.defs.layers),
		"level_fields": _parse_level_field_definitions(world_data.defs.levelFields),
	}
	return definitions

static func _parse_enum_definitions(enum_defs: Array) -> Dictionary:
	var parsed_enum_defs := {}

	for enum_def in enum_defs:
		var uid = int(enum_def.uid)
		var values := []
		for value in enum_def.values:
			values.append({
				"value": value.id,
				"color": Color.from_string(str(value.color), Color.MAGENTA),
				"tileRect": value.tileRect
			})
		parsed_enum_defs[uid] = values

	return parsed_enum_defs

static func _parse_entity_definitions(entity_defs: Array) -> Dictionary:
	var parsed_entity_defs := {}

	for entity_def in entity_defs:
		var entity_tile = entity_def.uiTileRect
		if entity_tile == null:
			entity_tile = entity_def.tileRect

		var uid = int(entity_def.uid)
		parsed_entity_defs[uid] = {
			"uid": uid,
			"identifier": entity_def.identifier,
			"color": Color.from_string(entity_def.color, Color.MAGENTA),
			"renderMode": entity_def.renderMode,
			"hollow": entity_def.hollow,
			"tags": entity_def.tags,
			"field_defs": _parse_entity_field_defs(entity_def.fieldDefs),
			"tile": entity_tile
		}

	return parsed_entity_defs

static func _parse_layer_definitions(layer_defs: Array) -> Dictionary:
	var parsed_layer_defs := {}

	for layer_def in layer_defs:
		var uid = int(layer_def.uid)
		parsed_layer_defs[uid] = {
			"uid": uid,
			"type": layer_def.type,
			"identifier": layer_def.identifier,
			"gridSize": layer_def.gridSize,
			"offset": Vector2i(layer_def.pxOffsetX, layer_def.pxOffsetY),
			"parallax": Vector2(layer_def.parallaxFactorX, layer_def.parallaxFactorY),
			"parallaxScaling": layer_def.parallaxScaling,
			"intGridValues": layer_def.intGridValues
		}

	return parsed_layer_defs

static func _parse_tileset_definitions(tileset_defs: Array, layer_defs: Array) -> Dictionary:
	var parsed_tileset_defs := {}

	for tileset_def in tileset_defs:
		var uid = int(tileset_def.uid)
		parsed_tileset_defs[uid] = {
			"uid": uid,
			"identifier": tileset_def.identifier,
			"relPath": tileset_def.relPath,
			"gridSize": tileset_def.tileGridSize,
			"pxWid": tileset_def.pxWid,
			"pxHei": tileset_def.pxHei,
			"spacing": tileset_def.spacing,
			"padding": tileset_def.padding,
			"tags": tileset_def.tags,
			"enumTagUid": tileset_def.tagsSourceEnumUid,
			"enumTags": tileset_def.enumTags,
			"customData": tileset_def.customData,
			"__cWid": tileset_def.__cWid,
			"__cHei": tileset_def.__cHei,
		}
	return parsed_tileset_defs

static func _parse_entity_field_defs(field_defs: Array) -> Dictionary:
	var parsed_entity_field_defs := {}

	for field_def in field_defs:
		parsed_entity_field_defs[int(field_def.uid)] = {
			"identifier": field_def.identifier,
			"type": field_def.__type,
		}

	return parsed_entity_field_defs

static func _parse_level_field_definitions(level_field_defs: Array) -> Dictionary:
	var parsed_level_field_defs := {}

	for level_field_def in level_field_defs:
		parsed_level_field_defs[int(level_field_def.uid)] = {
			"identifier": level_field_def.identifier,
			"type": level_field_def.__type
		}

	return parsed_level_field_defs

# Returns if mapper resource is dirty and should be saved.
static func update_entity_mapper(mapper: LDTKEntityMapper, definitions: Dictionary) -> bool:
	var dirty := false
	var entity_defs: Dictionary = definitions.entities
	var entity_maps: Dictionary = mapper.entities.duplicate(true)

	# Add keys for all entities without an assigned scene - don't overwrite.
	for def in entity_defs:
		var id: String = entity_defs[def].identifier
		if not id in entity_maps:
			entity_maps[id] = null
			dirty = true

	# Entity in Mapper not found in Defitions - remove.
	var ids = entity_defs.values().map(func(a): return a.identifier)
	for key in entity_maps.keys():
		if not key in ids:
			entity_maps.erase(key)
			dirty = true

	mapper.entities = entity_maps
	return dirty

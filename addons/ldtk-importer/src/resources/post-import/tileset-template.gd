@tool

# Tileset Post-Import Template for LDTK-Importer.

func post_import(tilesets: Dictionary) -> Dictionary:
	for tileset: TileSet in tilesets.values():
		# Behaviour goes here
		#print("Tileset: ", tileset, tileset.tile_size)
		pass
	return tilesets

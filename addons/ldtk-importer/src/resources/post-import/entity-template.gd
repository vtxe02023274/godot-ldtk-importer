@tool

# EntityLayer Post-Import Template for LDTK-Importer.

func post_import(entity_layer: LDTKEntityLayer) -> LDTKEntityLayer:
	for entity: Dictionary in entity_layer.entities:
		# Behaviour goes here
		pass

	return entity_layer

#@tool
#
### EntityLayer Post-Import: Add Lights
### NOTE: This is currently used by /examples/gridvania.ldtk. Please do not edit directly.
### Creates Light nodes on all 'LightTest' entities.
#
##const Light = preload("res://examples/light.tscn")
#
## Used to update entity reference
#const LDTKUtil = preload("res://addons/ldtk-importer/src/util/util.gd")
#
#func post_import(entity_layer: LDTKEntityLayer) -> LDTKEntityLayer:
	#print('SPAWN LIGHTS')
	## Loop though the 'entities' Dictionary on the EntityLayer
	#for entity: Dictionary in entity_layer.entities:
		## Find 'LightTest' entity
		#if entity.identifier != "LightTest": continue
#
		## Create a new Light instance.
		##var light = Light.instantiate()
		#var light: PointLight2D = PointLight2D.new()
		#light.name = entity.identifier
#
		## Copy fields over to the new instance.
		#light.position = entity.position
		## TODO: Fix 'size' to not shadow Dictionary.size
		##light.scale = Vector2(entity.size) / Vector2(64,64)
		#light.color = entity.smart_color
		#light.energy = entity.fields.Energy
#
		## Add instance to the EntityLayer node.
		#entity_layer.add_child(light)
		##if entity_layer.owner:
			##light.set_owner(entity_layer.owner)
		#print('spawn light: %s' % [light.name])
#
		##if light.owner:
			##print('spawn light: %s %s' % [light.name, light.owner.name])
#
		## Update Entity Reference
		##LDTKUtil.update_instance_reference(entity.iid, light)
#
	#return entity_layer

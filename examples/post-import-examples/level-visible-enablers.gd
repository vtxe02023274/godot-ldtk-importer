@tool
extends LDTKLevelPostImporter

## Level Post-Import: Add VisibleEnablers
## VisibleOnScreenEnablers are used to enable/disable nodes when they appear/disappear on screen.
## This is useful to optimise your game by reducing unnecessary processing.

func post_import(level: LDTKLevel) -> LDTKLevel:
	var visible_enabler: VisibleOnScreenEnabler2D = VisibleOnScreenEnabler2D.new()
	visible_enabler.rect = Rect2(Vector2.ZERO, level.size)
	level.add_child(visible_enabler)
	return level

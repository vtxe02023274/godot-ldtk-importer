@tool
extends EditorPlugin

var ldtk_plugin: EditorImportPlugin
var config = ConfigFile.new()

func _enter_tree() -> void:
	var config = ConfigFile.new()
	var err := config.load("res://addons/ldtk-importer/plugin.cfg")

	if err != OK:
		push_error("Config file not found.")
		return

	var version: String = config.get_value("plugin", "version", "0.0")

	ldtk_plugin = preload("ldtk-importer.gd").new()
	add_import_plugin(ldtk_plugin)
	add_autoload_singleton("LDTK", "ldtk-autoload.gd")

	print_rich("[color=#ffcc00]█ Godot-LDtk-Importer █[/color] %s | [url=https://gleeson.dev]@gleeson.dev[/url] | [url=https://github.com/heygleeson/godot-ldtk-importer]View on Github[/url]" % [version])

func _exit_tree() -> void:
	remove_import_plugin(ldtk_plugin)
	remove_autoload_singleton("LDTK")
	ldtk_plugin = null

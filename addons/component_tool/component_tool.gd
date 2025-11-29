@tool
extends EditorPlugin
var enabled: bool = false

func _enable_plugin() -> void:
	# Add autoloads here.
	add_autoload_singleton("CTM", "res://addons/component_tool/core/component_tool_manager.gd")
	enabled = true
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	remove_autoload_singleton("CTM")
	enabled = false
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	if not enabled:
		_enable_plugin()
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	if enabled:
		_disable_plugin()
	pass

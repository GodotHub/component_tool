@tool
extends EditorPlugin
var enabled: bool = false
var man_ui


func _enable_plugin() -> void:
	if enabled:
		return
	man_ui = preload("res://addons/component_tool/ui/comp_center.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, man_ui)
	
	pass


func _disable_plugin() -> void:
	if not enabled:
		return
	remove_control_from_docks(man_ui)
	man_ui.free()
	enabled = false
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	_enable_plugin()
	enabled = true
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	_disable_plugin()
	enabled = false
	pass

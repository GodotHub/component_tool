@tool
class_name CompItem
extends HBoxContainer
@onready var comp_enable: CheckButton = $CompEnable
@onready var comp_name: Label = $Label
var manager: ComponentToolManager 

func _ready() -> void:
	# 其他位置也可能触发切换
	manager.comp_enable_changed.connect(_on_comp_enable_changed)
	pass

func _on_comp_enable_toggled(toggled_on: bool) -> void: 
	manager.set_current_node_comp_enable(comp_name.text, toggled_on)
	comp_enable.button_pressed = toggled_on
	
func _on_comp_enable_changed(host: Node, comp_name: String, enable: bool):
	if comp_name == comp_name and host == ComponentUtil.get_current_selected_node():
		_on_comp_enable_toggled(enable)
	pass
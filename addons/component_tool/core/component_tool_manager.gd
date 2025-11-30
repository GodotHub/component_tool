@tool
class_name ComponentToolManager
extends Node

signal comp_enable_changed(host: Node, comp_name: String, enable: bool)

func set_current_node_comp_enable(comp_name: String, enable: bool):
	var host: Node = ComponentUtil.get_current_selected_node()
	if ComponentUtil.set_current_selected_node_comp_enable(comp_name, enable):
		comp_enable_changed.emit(host, comp_name, enable)
	
func set_node_comp_enable(node: Node, comp_name: String, enable: bool):
	if ComponentUtil.set_node_comp_enable(node, comp_name, enable):
		comp_enable_changed.emit(node, comp_name, enable)
	

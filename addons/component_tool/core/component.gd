@abstract
class_name Component
extends Node

@export var comp_enable: bool = true: set = set_comp_enable
@export var component_host: Node
@export var component_name: String 
	
@abstract func _enable()
@abstract func _disable()

func _enter_tree() -> void:
	if not component_host:
		component_host = get_parent()
	add_to_group("components")
	if comp_enable:
		set_comp_enable(comp_enable)
		
func set_comp_enable(value: bool):
	comp_enable = value
	if not is_node_ready():
		await ready
	if value:
		_enable()
	else:
		_disable()
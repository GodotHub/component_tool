@abstract
"""组件基类
所有组件的抽象父类，定义了组件的基本行为和接口
"""
class_name Component
extends Node

"""组件启用状态
当设置为true时启用组件，false时禁用组件
"""
@export var comp_enable: bool = true: set = set_comp_enable
"""组件的宿主节点
通常是组件的父节点
"""
@export var component_host: Node
"""组件名称
用于标识组件
"""
@export var component_name: String
	
"""组件启用时调用的抽象方法
子类必须实现此方法，用于初始化组件
"""
@abstract func _enable()
"""组件禁用时调用的抽象方法
子类必须实现此方法，用于清理组件资源
"""
@abstract func _disable()

"""节点进入树时调用
初始化组件宿主和组件组
"""
func _enter_tree() -> void:
	# 如果没有指定宿主，则默认使用父节点
	if not component_host:
		component_host = get_parent()
	# 添加到组件组，便于统一管理
	add_to_group("components")
	# 如果组件默认启用，则调用启用方法
	if comp_enable:
		set_comp_enable(comp_enable)
		
"""设置组件启用状态

参数:
- value: 启用状态(true为启用，false为禁用)
"""
func set_comp_enable(value: bool):
	comp_enable = value
	# 确保节点已准备就绪
	if not is_node_ready():
		await ready
	# 根据状态调用对应的方法
	if value:
		_enable()
	else:
		_disable()
@tool
"""组件工具管理器
用于管理组件的启用/禁用状态变化
"""
class_name ComponentToolManager
extends Node

"""组件启用状态改变信号

参数:
- host: 组件所在的宿主节点
- comp_name: 组件名称
- enable: 启用状态(true为启用，false为禁用)
"""
signal comp_enable_changed(host: Node, comp_name: String, enable: bool)

"""设置当前选中节点的组件启用状态

参数:
- comp_name: 组件名称
- enable: 启用状态(true为启用，false为禁用)
"""
func set_current_node_comp_enable(comp_name: String, enable: bool):
	var host: Node = ComponentUtil.get_current_selected_node()
	if ComponentUtil.set_current_selected_node_comp_enable(comp_name, enable):
		# 发出状态改变信号
		comp_enable_changed.emit(host, comp_name, enable)
	
"""设置指定节点的组件启用状态

参数:
- node: 组件所在的宿主节点
- comp_name: 组件名称
- enable: 启用状态(true为启用，false为禁用)
"""
func set_node_comp_enable(node: Node, comp_name: String, enable: bool):
	if ComponentUtil.set_node_comp_enable(node, comp_name, enable):
		# 发出状态改变信号
		comp_enable_changed.emit(node, comp_name, enable)

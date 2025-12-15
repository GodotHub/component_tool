@tool
"""组件工具插件
Godot编辑器插件，提供组件化开发功能
"""
extends EditorPlugin
"""插件启用状态
"""
var enabled: bool = false
"""主界面节点
"""
var man_ui

"""启用插件
初始化插件界面并添加到编辑器
"""
func _enable_plugin() -> void:
	if enabled:
		return
	# 预加载并实例化主界面
	man_ui = preload("res://addons/component_tool/ui/comp_center.tscn").instantiate()
	# 添加到编辑器右侧上方的停靠区
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, man_ui)
	
	pass

"""禁用插件
清理插件资源并从编辑器中移除
"""
func _disable_plugin() -> void:
	if not enabled:
		return
	# 从编辑器停靠区移除界面
	remove_control_from_docks(man_ui)
	# 释放界面资源
	man_ui.free()
	enabled = false
	pass

"""插件进入树时调用
初始化插件
"""
func _enter_tree() -> void:
	# 启用插件
	_enable_plugin()
	enabled = true
	pass

"""插件退出树时调用
清理插件
"""
func _exit_tree() -> void:
	# 禁用插件
	_disable_plugin()
	enabled = false
	pass
@tool
"""组件项界面
用于显示和管理单个组件的启用状态
"""
class_name CompItem
extends HBoxContainer
"""组件启用状态复选框
"""
@onready var comp_enable: CheckButton = $CompEnable
"""组件名称标签
"""
@onready var comp_name: Label = $Label
"""组件工具管理器
"""
var manager: ComponentToolManager

"""节点准备就绪时调用
连接组件启用状态变化信号
"""
func _ready() -> void:
	# 连接管理器的组件启用状态变化信号
	manager.comp_enable_changed.connect(_on_comp_enable_changed)
	pass

"""组件启用复选框状态变化时调用
更新组件的启用状态

参数:
- toggled_on: 新的启用状态
"""
func _on_comp_enable_toggled(toggled_on: bool) -> void:
	# 通过管理器设置当前节点的组件启用状态
	manager.set_current_node_comp_enable(comp_name.text, toggled_on)
	# 更新复选框的选中状态
	comp_enable.button_pressed = toggled_on

"""组件启用状态变化时调用
处理来自管理器的组件启用状态变化

参数:
- host: 宿主节点
- comp_name: 组件名称
- enable: 新的启用状态
"""
func _on_comp_enable_changed(host: Node, comp_name: String, enable: bool):
	# 检查是否是当前节点的当前组件
	if self.comp_name.text == comp_name and host == ComponentUtil.get_current_selected_node():
		# 更新复选框状态
		_on_comp_enable_toggled(enable)
	pass
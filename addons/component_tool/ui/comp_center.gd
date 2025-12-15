@tool
"""组件工具主界面
组件工具的主界面控制器，负责管理界面元素和用户交互
"""
class_name CompCenter
extends Panel

"""主标签容器
"""
@onready var tab_container: TabContainer = %TabContainer
"""宿主标签容器
"""
@onready var tab_container_host: TabContainer = %TabContainerHost
"""组件项容器
"""
@onready var item_container: VBoxContainer = %ItemContainer
"""查询编辑器
"""
@onready var query_edit: LineEdit = %QueryEdit

"""创建组件界面预加载
"""
var create_ui_preload: PackedScene = preload("res://addons/component_tool/ui/create_component.tscn")
"""组件项界面预加载
"""
var item_ui_preload: PackedScene = preload("res://addons/component_tool/ui/comp_item.tscn")
"""组件工具管理器
"""
var manager: ComponentToolManager

"""创建组件界面实例
"""
var create_component: CreateComponent

"""当前节点相关类型
"""
var current_node_relation_types: Array[String] = []

"""节点准备就绪时调用
初始化管理器和事件监听
"""
func _ready() -> void:
	if Engine.is_editor_hint():
		# 创建并添加组件管理器
		manager = ComponentToolManager.new()
		add_child(manager)
		# 监听选择变化事件
		EditorInterface.get_selection().selection_changed.connect(on_selection_changed)

"""选择变化时调用
更新界面显示根据当前选择的节点
"""
func on_selection_changed() -> void:
	var selection: Node = ComponentUtil.get_current_selected_node()
	if not selection:
		return

	# 获取当前节点的所有类型
	var all_types: Array[String] = ComponentUtil.get_object_all_types(selection)

	current_node_relation_types = all_types

	# 根据选择的节点类型切换标签页
	if selection is Component:
		tab_container.set_current_tab(1)
	else:
		tab_container.set_current_tab(0)
		# 检查是否有组件
		var children: Array[Node] = selection.find_children("*Component", "", false)
		var has_comp: bool = false
		for child in children:
			if child is Component:
				has_comp = true

		# 根据是否有组件切换标签页
		if has_comp:
			tab_container_host.set_current_tab(1)
			# 更新组件列表
			update_item_list(selection, query_edit.text)
		else:
			tab_container_host.set_current_tab(0)

"""更新组件列表

参数:
- selection: 当前选中的节点
- filter: 筛选条件
"""
func update_item_list(selection: Node, filter: String):
	# 清空现有组件项
	var children: Array[Node] = item_container.get_children()
	for child in children:
		child.queue_free()

	# 获取所有组件
	var comps: Array[Component] = ComponentUtil.find_all_comp(selection)
	for comp in comps:
		# 创建组件项并设置属性
		var comp_item: CompItem = item_ui_preload.instantiate()
		comp_item.manager = manager
		item_container.add_child(comp_item)
		comp_item.comp_name.text = comp.component_name
		comp_item.comp_enable.button_pressed = comp.comp_enable

"""创建组件按钮点击时调用
打开组件创建界面
"""
func _on_button_create_pressed() -> void:
	# 实例化并显示创建组件界面
	create_component = create_ui_preload.instantiate()
	self.add_child(create_component)
	create_component.popup_centered()
	# 设置宿主类型
	create_component.set_host_types(current_node_relation_types)
	# 连接关闭和创建完成信号
	create_component.close_requested.connect(on_window_close)
	create_component.create_finished.connect(on_selection_changed)

"""窗口关闭时调用
清理创建组件界面
"""
func on_window_close():
	create_component.queue_free()
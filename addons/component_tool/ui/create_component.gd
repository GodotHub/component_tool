@tool
"""创建组件界面
用于创建新组件的窗口界面控制器
"""
class_name CreateComponent
extends Window
"""宿主类型选择按钮
"""
@onready var types_option_button: OptionButton = %TypesOptionButton
"""位置选择按钮
"""
@onready var location_option_button: OptionButton = %LocationOptionButton
"""代码编辑器
"""
@onready var code_edit: CodeEdit = %CodeEdit
"""组件功能名称输入框
"""
@onready var component_func_name: LineEdit = %ComponentFuncName
"""文件路径输入框
"""
@onready var line_edit_file: LineEdit = %LineEditFile
"""文件对话框
"""
@onready var file_dialog: FileDialog = $FileDialog

"""模板选择按钮
"""
@onready var templates_option_button: OptionButton = %TemplatesOptionButton


"""宿主类型字典
键为索引，值为类型名称
"""
var host_dict: Dictionary[int, String] = {}
"""位置字典
键为索引，值为位置名称
"""
var location_dict: Dictionary[int, String] = {}

var current_template_file: String = ComponentUtil.TemplateComponentFile

"""创建完成信号
组件创建成功后发出
"""
signal create_finished()

"""节点准备就绪时调用
初始化位置字典
"""
func _ready() -> void:
	location_dict.clear()
	for i in location_option_button.get_item_count():
		var text: String = location_option_button.get_item_text(i)
		location_dict[i] = text

	## 在 res://addons/component_tool/template/ 中遍历所有模板文件添加到 templates_option_button 中
	var template_dir: String = "res://addons/component_tool/template/"
	var template_files: Array[String] = ComponentUtil.get_files_in_dir(template_dir)
	var index = 0
	for template_file in template_files:
		templates_option_button.add_item(template_file, index)
		if template_file == current_template_file:
			templates_option_button.select(index)
		index += 1
		pass
	
	
"""设置宿主类型选项

参数:
- all_types: 宿主类型数组
"""
func set_host_types(all_types: Array[String]) -> void:
	host_dict.clear()
	var index: int = 0
	for item in all_types:
		types_option_button.add_item(item, index)
		host_dict[index] = item
		index += 1
	types_option_button.select(0)
	pass
	
"""获取当前选择的宿主类型

返回值:
- String: 当前选择的宿主类型名称
"""
func get_current_host_type() -> String:
	return types_option_button.get_item_text(types_option_button.get_selected())
	
"""位置选择按钮项选中时调用
更新界面
"""
func _on_location_option_button_item_selected(index: int) -> void:
	update_ui()
	pass

"""更新界面
根据当前输入更新代码预览和文件路径
"""
func update_ui():
	var script_dir: String = ComponentUtil.DefaultGenScriptDir
	# 如果选择用户位置，则使用当前选中节点的脚本路径
	if location_dict[location_option_button.get_selected()] == "用户位置":
		script_dir = ComponentUtil.get_node_script_path(ComponentUtil.get_current_selected_node())
	
	# 更新代码预览
	code_edit.text = ComponentUtil.get_template(component_func_name.text, get_current_host_type(), current_template_file)
	
	# 更新文件路径
	var path: String = ComponentUtil.get_component_file_name(component_func_name.text, get_current_host_type(), script_dir)
	line_edit_file.text = path
	pass

"""组件功能名称文本变化时调用
更新界面
"""
func _on_component_func_name_text_changed(new_text: String) -> void:
	update_ui()
	
"""宿主类型选择按钮项选中时调用
更新界面
"""
func _on_types_option_button_item_selected(index: int) -> void:
	update_ui()

func _on_templates_option_button_item_selected(index: int) -> void:
	current_template_file = templates_option_button.get_item_text(index)
	update_ui()

"""浏览按钮按下时调用
打开文件对话框选择生成位置
"""
func _on_button_open_dir_pressed() -> void:
	file_dialog.popup_centered()
	pass

"""创建按钮按下时调用
创建组件文件并添加到节点
"""
func _on_button_create_pressed() -> void:
	# 创建组件文件
	ComponentUtil.create_file_in_res(line_edit_file.text, code_edit.text)
	# 扫描资源文件系统以更新编辑器
	EditorInterface.get_resource_filesystem().scan()
	# 添加组件到当前选中的节点
	ComponentUtil.add_child_node(ComponentUtil.get_current_selected_node(), line_edit_file.text)
	# 隐藏窗口
	hide()
	# 保存场景
	ComponentUtil.save_scene()
	# 发出创建完成信号
	create_finished.emit()
	pass

"""文件对话框确认时调用
更新文件路径
"""
func _on_file_dialog_confirmed() -> void:
	var script_file_name: String = line_edit_file.text.get_file()
	line_edit_file.text = file_dialog.current_path.path_join(script_file_name)
	pass

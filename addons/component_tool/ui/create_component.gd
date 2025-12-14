@tool
class_name CreateComponent
extends Window
@onready var types_option_button: OptionButton = %TypesOptionButton
@onready var location_option_button: OptionButton = %LocationOptionButton
@onready var code_edit: CodeEdit = %CodeEdit
@onready var component_func_name: LineEdit = %ComponentFuncName
@onready var line_edit_file: LineEdit = %LineEditFile
@onready var file_dialog: FileDialog = $FileDialog

var host_dict: Dictionary[int, String] = {}
var location_dict: Dictionary[int, String] = {}

signal create_finished()

func _ready() -> void:
	location_dict.clear()
	for i in location_option_button.get_item_count():
		var text: String = location_option_button.get_item_text(i)
		location_dict[i] = text


func set_host_types(all_types: Array[String]) -> void:
	host_dict.clear()
	var index: int = 0
	for item in all_types:
		types_option_button.add_item(item, index)
		host_dict[index] = item
		index += 1
	types_option_button.select(0)
	pass
	

func get_current_host_type() -> String:
	return types_option_button.get_item_text(types_option_button.get_selected())
	

func _on_location_option_button_item_selected(index: int) -> void:
	update_ui()
	pass # Replace with function body.


func update_ui():
	var script_dir: String = ComponentUtil.DefaultGenScriptDir
	if location_dict[location_option_button.get_selected()] == "用户位置":
		script_dir = ComponentUtil.get_node_script_path(ComponentUtil.get_current_selected_node())
	
	code_edit.text =  ComponentUtil.get_template(component_func_name.text, get_current_host_type())
	
	var path: String = ComponentUtil.get_component_file_name(component_func_name.text, get_current_host_type(), script_dir)
	line_edit_file.text = path
	pass

func _on_component_func_name_text_changed(new_text: String) -> void:
	update_ui()
	
func _on_types_option_button_item_selected(index: int) -> void:
	update_ui()


func _on_button_open_dir_pressed() -> void:
	file_dialog.popup_centered()
	pass # Replace with function body.


func _on_button_create_pressed() -> void:
	ComponentUtil.create_file_in_res(line_edit_file.text, code_edit.text)
	EditorInterface.get_resource_filesystem().scan()
	ComponentUtil.add_child_node(ComponentUtil.get_current_selected_node(), line_edit_file.text)
	hide()
	ComponentUtil.save_scene()
	create_finished.emit()
	pass # Replace with function body.


func _on_file_dialog_confirmed() -> void:
	var script_file_name: String = line_edit_file.text.get_file()
	line_edit_file.text = file_dialog.current_path.path_join(script_file_name)
	pass # Replace with function body.

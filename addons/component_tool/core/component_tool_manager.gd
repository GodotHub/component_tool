@tool
extends Node

var current_node_relation_types: Array[String] = []


#func _ready():
#	if Engine.is_editor_hint():
#		print("CTM loaded")
#		EditorInterface.get_selection().selection_changed.connect(on_selection_changed)
#
#
#func on_selection_changed():
#	var selection: Node = ComponentUtil.get_current_selected_node()
#	var all_types: Array[String] = ComponentUtil.get_object_all_types(selection)
#	print("Curent node path ", ComponentUtil.get_node_script_path(selection))
#	current_node_relation_types = all_types
#	print(all_types)
#	if all_types.size() != 0:
#		var file_content: String = ComponentUtil.get_template("Movement", all_types[0])
#		var file_full_path: String = ComponentUtil.get_component_file_name("Movement", all_types[0])
#		print("file conent ", file_content)
#		print("file_full_path ", file_full_path)
#		ComponentUtil.create_file_in_res(file_full_path, file_content)
#		ComponentUtil.add_child_node(selection, file_full_path)
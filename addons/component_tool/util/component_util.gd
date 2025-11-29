@tool
extends Node
class_name ComponentUtil

static var DefaultGenScriptDir: String = "res://addons/component_tool/custom_component"
static var TemplateComponentFile: String = "res://addons/component_tool/template/compent_template.txt"

# 此函数用于获取一个对象所有继承的类 + 自身的类 包含 class_name
static func get_object_all_types(obj: Object) -> Array[String]:
	var types: Array[String] = []
	var host_script: Script = obj.get_script()
	var class_name_str: String = ""
	var top_level_type: String = ""
	if host_script:
		class_name_str = host_script.get_global_name()
		if class_name_str != "":
			if class_name_str not in types:
				types.append(class_name_str)
			top_level_type = host_script.get_instance_base_type()
	else:
		top_level_type = obj.get_class()

	# 获取 top_level_type 所有父类  
	while top_level_type != "":
		if top_level_type not in types:
			types.append(top_level_type)
		top_level_type = ClassDB.get_parent_class(top_level_type)
	
	return types

# 获取当前选中的节点 仅返回一个
static func get_current_selected_node() -> Node:
	var selected_nodes: Array[Node] =  EditorInterface.get_selection().get_top_selected_nodes()
	print(selected_nodes)
	if selected_nodes.size() > 0:
		return selected_nodes[0]
	else:
		return null

# 指定一个节点 如果其上有挂载脚本 返回脚本所在文件夹		
static func get_node_script_path(node: Node) -> String:
	var script: Script = node.get_script()
	if script:
		var resource_path := script.resource_path
		return FileAccess.open(resource_path, FileAccess.READ).get_path().get_base_dir()
		
	return "res://"
		
	
# 返回模板文件替换后的内容		
# component_name		组件名称
# host_type				宿主类型
static func get_template(component_name: String, host_type: String) -> String:
	var comp_template_file: FileAccess = FileAccess.open(TemplateComponentFile, FileAccess.READ)
	var template_content: String = comp_template_file.get_as_text()
	template_content = template_content.replace("<ComponentName>", component_name.to_pascal_case())\
							.replace("<HostName>", host_type.to_snake_case())\
							.replace("<HostType>", host_type)
							
	return template_content

# 获取组件文件的完整路径名
# component_name 	组件名称，应为大驼峰风格
# host_type 		宿主类型，应为大驼峰风格
# script_dir 		生成位置
static func get_component_file_name(component_name: String, host_type: String, 
									script_dir: String = DefaultGenScriptDir) -> String:
	var name: String = host_type + component_name + "Component"
	var snake_name: String = name.to_snake_case()
	var full_path: String = "{0}/{1}.gd".format([script_dir, snake_name])
	return full_path
	
# 创建文件并写入内容 如果失败则返回false 否则返回true	
# file_full_path		文件的完整路径
# content				文件内容
static func create_file_in_res(file_full_path: String, content: String) -> bool:
	var file_access := FileAccess.open(file_full_path, FileAccess.WRITE)
	if not file_access:
		push_error("无法创建文件{0}， 错误： {1}".format([file_full_path, FileAccess.get_open_error()]))	
		return false
	var ret: bool = file_access.store_string(content)
	if not ret:
		push_error("文件{0}写入失败：{1}".format([file_full_path, file_access.get_error()]))
	file_access.close()
	return ret
	
# 在节点上创建一个脚本子节点
static func add_child_node(parent_node: Node, script_path: String):
	var component: Script = load(script_path)
	var node: Node = component.new()
	parent_node.add_child(node)
	node.owner = EditorInterface.get_edited_scene_root()
	node.name = component.get_global_name()
	pass
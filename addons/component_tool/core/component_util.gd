@tool
"""组件工具类
提供组件管理的各种实用功能，包括组件创建、查找、启用/禁用等操作
"""
extends Node
class_name ComponentUtil

# 默认生成脚本的目录路径
static var DefaultGenScriptDir: String = "res://addons/component_tool/custom_component"
# 组件模板文件路径
static var TemplateComponentFile: String = "res://addons/component_tool/template/component_template.txt"

"""获取对象的所有类型继承链
包括对象自身的类名(如果有class_name定义)及其所有父类

参数:
- obj: 需要获取类型的对象

返回值:
- Array[String]: 包含对象所有类型的数组，从最具体的类到最基础的类
"""
static func get_object_all_types(obj: Object) -> Array[String]:
	var types: Array[String] = []
	var host_script: Script = obj.get_script()
	var class_name_str: String = ""
	var top_level_type: String = ""
	if host_script:
		# 获取脚本的class_name(如果有定义)
		class_name_str = host_script.get_global_name()
		if class_name_str != "":
			if class_name_str not in types:
				types.append(class_name_str)
			# 获取脚本实例的基础类型
			top_level_type = host_script.get_instance_base_type()
	else:
		# 如果没有脚本，直接获取对象的类
		top_level_type = obj.get_class()

	# 递归获取所有父类
	while top_level_type != "":
		if top_level_type not in types:
			types.append(top_level_type)
		top_level_type = ClassDB.get_parent_class(top_level_type)
	
	return types

"""获取当前编辑器中选中的节点
仅返回第一个选中的节点

返回值:
- Node: 当前选中的节点，如果没有选中则返回null
"""
static func get_current_selected_node() -> Node:
	var selected_nodes: Array[Node] = EditorInterface.get_selection().get_top_selected_nodes()
	if selected_nodes.size() > 0:
		return selected_nodes[0]
	else:
		return null
		
"""获取当前选中节点的指定组件

参数:
- comp_name: 要查找的组件名称

返回值:
- Component: 找到的组件实例，如果不存在则返回null
"""
static func get_current_selected_node_comp(comp_name: String) -> Component:
	var current_node: Node = ComponentUtil.get_current_selected_node()
	if not current_node:
		push_warning("当前选中节点为空，因此无法找到指定的组件：", comp_name)
		return null
		
	return find_comp(current_node, comp_name)
	
"""激活或关闭当前选中节点的指定组件

参数:
- comp_name: 组件名称
- enable: 启用状态(true为启用，false为禁用)

返回值:
- bool: 如果状态发生改变则返回true，否则返回false
"""
static func set_current_selected_node_comp_enable(comp_name: String, enable: bool) -> bool:
	var comp: Component = get_current_selected_node_comp(comp_name)
	if comp and comp.comp_enable != enable:
		comp.comp_enable = enable
		return true
	return false

"""在指定节点上查找组件

参数:
- node: 要查找组件的父节点
- comp_name: 组件名称

返回值:
- Component: 找到的组件实例，如果不存在则返回null
"""
static func find_comp(node: Node, comp_name: String) -> Component:
	if not node:
		return null
	var comp: Component = node.find_child(comp_name)
	if not comp:
		return null
	return comp

"""列出指定节点的所有组件

参数:
- node: 要查找组件的父节点

返回值:
- Array[Component]: 包含所有找到的组件实例的数组
"""
static func find_all_comp(node: Node) -> Array[Component]:
	var ret: Array[Component] = []
	if not node:
		return []
		
	# 查找所有名称以Component结尾的子节点
	var children: Array[Node] = node.find_children("*Component", "", false)
	for child in children:
		# 确保是Component类型的实例
		if child is Component:
			ret.append(child)
			
	return ret

"""激活或关闭指定节点的组件

参数:
- node: 组件所在的父节点
- comp_name: 组件名称
- enable: 启用状态(true为启用，false为禁用)

返回值:
- bool: 如果状态发生改变则返回true，否则返回false
"""
static func set_node_comp_enable(node: Node, comp_name: String, enable: bool) -> bool:
	var comp: Component = find_comp(node, comp_name)
	if not comp:
		return false
	if comp.comp_enable != enable:
		comp.comp_enable = enable
		return true
	return false
		

"""获取节点挂载脚本的所在文件夹路径

参数:
- node: 要获取脚本路径的节点

返回值:
- String: 脚本所在的文件夹路径，如果节点没有挂载脚本则返回"res://"
"""
static func get_node_script_path(node: Node) -> String:
	var script: Script = node.get_script()
	if script:
		var resource_path := script.resource_path
		return FileAccess.open(resource_path, FileAccess.READ).get_path().get_base_dir()
		
	return "res://"
		
		
"""获取组件模板文件替换后的内容(版本2)

参数:
- component_name: 组件名称
- host_type: 宿主类型名称
- template_file_path: 模板文件路径

返回值:
- String: 替换后的模板内容
"""
static func get_template(component_name: String, host_type: String, template_file_path: String) -> String:
	var comp_template_file: FileAccess = FileAccess.open(template_file_path, FileAccess.READ)
	var template_content: String = comp_template_file.get_as_text()
	# 替换模板中的占位符
	template_content = template_content.replace("<ComponentName>", component_name.to_pascal_case()) \
							.replace("<HostName>", host_type.to_snake_case()) \
							.replace("<HostType>", host_type)
							
	return template_content

"""获取目录下所有txt文件的完整路径

参数:
- dir_path: 目录路径

返回值:
- Array[String]: 包含所有txt文件完整路径的数组
"""
static func get_files_in_dir(dir_path: String) -> Array[String]:
	var files: Array[String] = []
	var dir_access: DirAccess = DirAccess.open(dir_path)
	if not dir_access:
		push_error("无法打开目录{0}，错误：{1}".format([dir_path, DirAccess.get_open_error()]))
		return files
		
	dir_access.list_dir_begin()
	var file_name: String = dir_access.get_next()
	while file_name != "":
		if file_name.begins_with("."):
			file_name = dir_access.get_next()
			continue
		
		var full_path: String = dir_path + file_name
		if dir_access.current_is_dir():
			files.append_array(get_files_in_dir(full_path))
		else:
			if file_name.ends_with(".txt"):
				files.append(full_path)
				
		file_name = dir_access.get_next()
	dir_access.list_dir_end()
	return files

"""获取组件文件的完整路径名

参数:
- component_name: 组件名称，应为大驼峰风格
- host_type: 宿主类型，应为大驼峰风格
- script_dir: 生成位置，默认为DefaultGenScriptDir

返回值:
- String: 组件文件的完整路径
"""
static func get_component_file_name(component_name: String, host_type: String,
								script_dir: String = DefaultGenScriptDir) -> String:
	var name: String = host_type + component_name + "Component"
	var snake_name: String = name.to_snake_case()
	var full_path: String = "{0}/{1}.gd".format([script_dir, snake_name])
	return full_path
	
"""创建文件并写入内容

参数:
- file_full_path: 文件的完整路径
- content: 文件内容

返回值:
- bool: 创建成功返回true，失败返回false
"""
static func create_file_in_res(file_full_path: String, content: String) -> bool:
	var file_access := FileAccess.open(file_full_path, FileAccess.WRITE)
	if not file_access:
		push_error("无法创建文件{0}，错误：{1}".format([file_full_path, FileAccess.get_open_error()]))
		return false
	var ret: bool = file_access.store_string(content)
	if not ret:
		push_error("文件{0}写入失败：{1}".format([file_full_path, file_access.get_error()]))
	file_access.close()
	return ret
	
"""在节点上创建一个脚本子节点

参数:
- parent_node: 父节点
- script_path: 脚本文件路径
"""
static func add_child_node(parent_node: Node, script_path: String):
	var component: Script = load(script_path)
	var node: Node = component.new()
	parent_node.add_child(node)
	node.owner = EditorInterface.get_edited_scene_root()
	node.name = component.get_global_name()
	pass
	
"""保存当前编辑的场景
"""
static func save_scene():
	var current_scene: Node = EditorInterface.get_edited_scene_root()
	if current_scene != null:
		EditorInterface.save_scene()
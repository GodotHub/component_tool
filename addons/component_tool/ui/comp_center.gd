@tool
class_name CompCenter
extends Panel

@onready var tab_container: TabContainer = %TabContainer
@onready var tab_container_host: TabContainer = %TabContainerHost
@onready var item_container: VBoxContainer = %ItemContainer
@onready var query_edit: LineEdit = %QueryEdit

var create_ui_preload: PackedScene = preload("res://addons/component_tool/ui/create_component.tscn")
var item_ui_preload: PackedScene = preload("res://addons/component_tool/ui/comp_item.tscn")
var manager: ComponentToolManager

var create_component: CreateComponent

var current_node_relation_types: Array[String] = []
func _ready() -> void:
	if Engine.is_editor_hint():
		manager = ComponentToolManager.new()
		add_child(manager)
		EditorInterface.get_selection().selection_changed.connect(on_selection_changed)


func on_selection_changed() -> void:
	var selection: Node = ComponentUtil.get_current_selected_node()
	if not selection:
		return

	var all_types: Array[String] = ComponentUtil.get_object_all_types(selection)

	current_node_relation_types = all_types

	if selection is Component:
		tab_container.set_current_tab(1)
	else:
		tab_container.set_current_tab(0)
		var children: Array[Node] = selection.find_children("*Component", "", false)
		var has_comp: bool = false
		for child in children:
			if child is Component:
				has_comp = true

		if has_comp:
			tab_container_host.set_current_tab(1)
			update_item_list(selection, query_edit.text)
		else:
			tab_container_host.set_current_tab(0)


func update_item_list(selection: Node, filter: String):
	var children: Array[Node] = item_container.get_children()
	for child in children:
		child.queue_free()

	var comps: Array[Component] = ComponentUtil.find_all_comp(selection)
	for comp in comps:
		var comp_item: CompItem = item_ui_preload.instantiate()
		comp_item.manager = manager
		item_container.add_child(comp_item)
		comp_item.comp_name.text = comp.component_name
		comp_item.comp_enable.button_pressed = comp.comp_enable


func _on_button_create_pressed() -> void:
	create_component = create_ui_preload.instantiate()
	self.add_child(create_component)
	create_component.popup_centered()
	create_component.set_host_types(current_node_relation_types)
	create_component.close_requested.connect(on_window_close)
	create_component.create_finished.connect(on_selection_changed)


func on_window_close():
	create_component.queue_free()

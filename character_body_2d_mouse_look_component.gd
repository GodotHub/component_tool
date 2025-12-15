class_name CharacterBody2DMouseLookComponent
extends Component
# 宿主
var character_body_2d: CharacterBody2D

@export var rotation_speed: float = 5.0 # 转向速度(弧度/秒)


func _enable():
	# 获得类型提示
	character_body_2d = component_host
	component_name = "CharacterBody2DMouseLookComponent"
	pass

func _disable():
	pass

func _physics_process(delta: float) -> void:
	# 记得检查组件激活状态
	if not comp_enable:
		return
		
	# 获取鼠标位置
	var mouse_position = character_body_2d.get_global_mouse_position()

	var target_transform: Transform2D = character_body_2d.transform.looking_at(mouse_position)
	character_body_2d.transform = character_body_2d.transform.interpolate_with(target_transform, delta * rotation_speed)

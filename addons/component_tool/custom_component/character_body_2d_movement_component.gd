class_name CharacterBody2DMovementComponent
extends Component
# 宿主
var character_body_2d: CharacterBody2D

func _enable():
	# 获得类型提示
	character_body_2d = component_host
	pass

func _disable():
	pass

func _physics_process(delta: float) -> void:
	# 记得检查组件激活状态
	if not comp_enable:
		return

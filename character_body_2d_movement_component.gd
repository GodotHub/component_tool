class_name CharacterBody2DMovementComponent
extends Component
# 宿主
var character_body_2d: CharacterBody2D

@export var speed: float = 1000

func _enable():
	# 获得类型提示
	character_body_2d = component_host
	component_name = "CharacterBody2DMovementComponent"
	pass

func _disable():
	pass



func _physics_process(delta: float) -> void:
	# 记得检查组件激活状态
	if not comp_enable:
		return
		
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	character_body_2d.velocity = input_dir * speed
	character_body_2d.move_and_slide()

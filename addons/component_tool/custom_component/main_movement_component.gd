class_name MainMovementComponent
extends Component
# 宿主
var main: Main

func _enable():
	# 获得类型提示
	main = component_host
	pass

func _disable():
	pass

func _physics_process(delta: float) -> void:
	# 记得检查组件激活状态
	if not comp_enable:
		return

extends CharacterBody2D

const SPEED = 200.0
var current_interact_target = null

@onready var main = get_parent()

func _physics_process(delta):
	# 获取输入方向
	var direction = Input.get_axis("move_left", "move_right")
	
	# 应用移动
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# 检查是否接近学生
	check_nearby_students()

func check_nearby_students():
	var nearest_student = null
	var nearest_distance = 80.0  # 互动距离
	
	for student in main.student_nodes:
		var distance = global_position.distance_to(student.global_position)
		if distance < nearest_distance:
			nearest_student = student
			nearest_distance = distance
	
	# 如果按下了互动键
	if Input.is_action_just_pressed("interact"):
		if nearest_student:
			main.show_student_info(nearest_student)
		else:
			main.hide_student_info()
	
	# 更新交互目标高亮
	current_interact_target = nearest_student
	queue_redraw()

func _draw():
	# 绘制交互提示
	if current_interact_target:
		draw_circle(Vector2.ZERO, 30, Color(1, 1, 1, 0.3))
		draw_arc(Vector2.ZERO, 35, 0, TAU, 16, Color(1, 1, 1, 0.5), 2.0)

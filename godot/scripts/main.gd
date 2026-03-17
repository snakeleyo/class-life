extends Node2D

# ========== 游戏数据 ==========
var students_data = [
	{"name": "张伟", "x": 150, "y": 380, "status": "focus", "color": Color(0.659, 0.831, 0.902), "quote": "今天也要加油！", "hair": Color(0.173, 0.243, 0.314), "mood": "happy"},
	{"name": "李娜", "x": 280, "y": 380, "status": "focus", "color": Color(1, 0.718, 0.769), "quote": "好想快点下课呀～", "hair": Color(0.545, 0.271, 0.075), "mood": "bored"},
	{"name": "王强", "x": 410, "y": 380, "status": "daydream", "color": Color(0.659, 0.831, 0.902), "quote": "窗外的小鸟...", "hair": Color(0.1, 0.1, 0.1), "mood": "relaxed"},
	{"name": "刘芳", "x": 540, "y": 380, "status": "focus", "color": Color(1, 0.718, 0.769), "quote": "这道题好难啊", "hair": Color(0.545, 0, 0), "mood": "confused"},
	{"name": "陈刚", "x": 670, "y": 380, "status": "active", "color": Color(0.659, 0.831, 0.902), "quote": "老师！我知道！", "hair": Color(0.29, 0.216, 0.157), "mood": "excited"},
	{"name": "赵敏", "x": 150, "y": 480, "status": "daydream", "color": Color(1, 0.718, 0.769), "quote": "中午吃什么呢", "hair": Color(0.824, 0.412, 0.118), "mood": "thinking"},
	{"name": "孙杰", "x": 280, "y": 480, "status": "focus", "color": Color(0.659, 0.831, 0.902), "quote": "认真听讲中...", "hair": Color(0.184, 0.31, 0.31), "mood": "focused"},
	{"name": "周丽", "x": 410, "y": 480, "status": "dozing", "color": Color(1, 0.718, 0.769), "quote": "zzz...", "hair": Color(0.545, 0, 0.545), "mood": "sleepy"},
	{"name": "吴涛", "x": 540, "y": 480, "status": "focus", "color": Color(0.659, 0.831, 0.902), "quote": "笔记要做好", "hair": Color(0.333, 0.42, 0.184), "mood": "studious"},
	{"name": "郑雪", "x": 670, "y": 480, "status": "focus", "color": Color(1, 0.718, 0.769), "quote": "好困啊...", "hair": Color(1, 0.753, 0.796), "mood": "tired"},
	{"name": "钱程", "x": 150, "y": 580, "status": "focus", "color": Color(0.659, 0.831, 0.902), "quote": "考试加油！", "hair": Color(0.545, 0, 0.545), "mood": "motivated"},
	{"name": "孙悦", "x": 280, "y": 580, "status": "active", "color": Color(1, 0.718, 0.769), "quote": "有人要借笔吗", "hair": Color(1, 0.388, 0.278), "mood": "helpful"},
	{"name": "李龙", "x": 410, "y": 580, "status": "daydream", "color": Color(0.659, 0.831, 0.902), "quote": "放学去打球", "hair": Color(0, 0.392, 0), "mood": "excited"},
	{"name": "王燕", "x": 540, "y": 580, "status": "focus", "color": Color(1, 0.718, 0.769), "quote": "这道题我会！", "hair": Color(1, 0.078, 0.576), "mood": "happy"},
	{"name": "刘虎", "x": 670, "y": 580, "status": "focus", "color": Color(0.659, 0.831, 0.902), "quote": "肚子饿了...", "hair": Color(0.412, 0.412, 0.412), "mood": "hungry"}
]

# 课程表数据
var schedule_data = [
	{"time": "08:30", "name": "朝读", "teacher": ""},
	{"time": "09:00", "name": "语文", "teacher": "王老师"},
	{"time": "10:00", "name": "数学", "teacher": "张老师"},
	{"time": "11:00", "name": "英语", "teacher": "李老师"},
	{"time": "13:00", "name": "午休", "teacher": ""},
	{"time": "14:00", "name": "物理", "teacher": "赵老师"},
	{"time": "15:00", "name": "化学", "teacher": "刘老师"},
	{"time": "16:00", "name": "放学", "teacher": ""}
]

var student_nodes = []
var current_class = {"name": "数学", "teacher": "张老师", "time": "10:00"}
var time_timer = 0.0

@onready var time_label = $UI/TopBar/TimeLabel
@onready var date_label = $UI/TopBar/DateLabel
@onready var class_info_label = $UI/TopBar/ClassInfo
@onready var status_panel = $UI/StatusPanel
@onready var player = $Player
@onready var player_label = $Player/PlayerName

var player_name = "你"

# 状态图标
var status_icons = {
	"focus": "📖",
	"daydream": "🌸",
	"dozing": "💤",
	"active": "✋"
}

# 心情颜色
var mood_colors = {
	"happy": Color(1, 0.9, 0.4),
	"sad": Color(0.6, 0.7, 0.9),
	"excited": Color(1, 0.7, 0.5),
	"tired": Color(0.8, 0.8, 0.8),
	"confused": Color(0.9, 0.8, 0.6),
	"thinking": Color(0.7, 0.8, 1),
	"focused": Color(0.6, 0.9, 0.7),
	"studious": Color(0.8, 0.7, 1),
	"bored": Color(0.7, 0.7, 0.7),
	"relaxed": Color(0.7, 0.9, 0.8),
	"sleepy": Color(0.8, 0.8, 0.9),
	"motivated": Color(1, 0.8, 0.6),
	"helpful": Color(0.9, 0.8, 0.7),
	"hungry": Color(1, 0.6, 0.6)
}

func _ready():
	# 创建学生节点
	create_students()
	# 更新时间显示
	update_time_display()
	# 更新课程显示
	update_class_display()
	
	# 创建定时器
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()

func _process(delta):
	time_timer += delta
	
	# 更新学生动画
	update_student_animations()
	
	# 更新玩家状态显示
	update_player_label()

func create_students():
	var students_container = $Classroom/Students
	
	for i in range(students_data.size()):
		var data = students_data[i]
		var student = Node2D.new()
		student.position = Vector2(data.x, data.y)
		student.set_meta("data", data)
		student.set_meta("index", i)
		
		# 阴影
		var shadow = Polygon2D.new()
		var shadow_points = PackedVector2Array([
			Vector2(-20, 20), Vector2(20, 20),
			Vector2(15, 30), Vector2(-15, 30)
		])
		shadow.polygon = shadow_points
		shadow.color = Color(0, 0, 0, 0.15)
		student.add_child(shadow)
		
		# 身体
		var body = Polygon2D.new()
		var body_points = PackedVector2Array([
			Vector2(-18, -30), Vector2(18, -30),
			Vector2(22, 0), Vector2(18, 25),
			Vector2(-18, 25), Vector2(-22, 0)
		])
		body.polygon = body_points
		body.color = data.color
		student.add_child(body)
		
		# 头发
		var hair = Polygon2D.new()
		var hair_points = PackedVector2Array([
			Vector2(-20, -25), Vector2(20, -25),
			Vector2(18, -10), Vector2(-18, -10)
		])
		hair.polygon = hair_points
		hair.color = data.hair
		student.add_child(hair)
		
		# 眼睛
		var eyes = Node2D.new()
		eyes.set_meta("base_y", -5)
		student.add_child(eyes)
		
		var left_eye = Polygon2D.new()
		left_eye.polygon = PackedVector2Array([Vector2(-8, -5), Vector2(-4, -5), Vector2(-4, -1), Vector2(-8, -1)])
		left_eye.color = Color(0.2, 0.2, 0.2)
		eyes.add_child(left_eye)
		
		var right_eye = Polygon2D.new()
		right_eye.polygon = PackedVector2Array([Vector2(4, -5), Vector2(8, -5), Vector2(8, -1), Vector2(4, -1)])
		right_eye.color = Color(0.2, 0.2, 0.2)
		eyes.add_child(right_eye)
		
		eyes.set_meta("type", data.status)
		
		# 腮红 (某些心情)
		if data.mood in ["happy", "excited", "bored"]:
			var blush = Polygon2D.new()
			blush.polygon = PackedVector2Array([Vector2(-15, 5), Vector2(-10, 8), Vector2(-10, 2)])
			blush.color = Color(1, 0.6, 0.6, 0.4)
			student.add_child(blush)
		
		# 名字标签
		var name_label = Label.new()
		name_label.text = data.name
		name_label.position = Vector2(-25, 35)
		name_label.add_theme_font_size_override("font_size", 14)
		name_label.add_theme_color_override("font_color", Color.WHITE)
		name_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.5))
		name_label.add_theme_constant_override("shadow_offset_x", 1)
		name_label.add_theme_constant_override("shadow_offset_y", 1)
		student.add_child(name_label)
		
		# 状态图标
		var status_label = Label.new()
		status_label.text = status_icons[data.status]
		status_label.position = Vector2(15, -50)
		status_label.add_theme_font_size_override("font_size", 20)
		student.add_child(status_label)
		student.set_meta("status_label", status_label)
		
		# 心情气泡
		var mood_bubble = Label.new()
		mood_bubble.text = get_mood_emoji(data.mood)
		mood_bubble.position = Vector2(25, -35)
		mood_bubble.add_theme_font_size_override("font_size", 16)
		student.add_child(mood_bubble)
		student.set_meta("mood_bubble", mood_bubble)
		
		students_container.add_child(student)
		student_nodes.append(student)

func get_mood_emoji(mood):
	var emojis = {
		"happy": "😊",
		"sad": "😢",
		"excited": "🤩",
		"tired": "😫",
		"confused": "😕",
		"thinking": "🤔",
		"focused": "🙂",
		"studious": "📚",
		"bored": "😴",
		"relaxed": "😌",
		"sleepy": "😪",
		"motivated": "💪",
		"helpful": "🤝",
		"hungry": "🍚"
	}
	return emojis.get(mood, "😐")

func update_student_animations():
	var t = Time.get_ticks_msec() / 1000.0
	
	for student in student_nodes:
		var data = student.get_meta("data")
		var status_label = student.get_meta("status_label")
		var mood_bubble = student.get_meta("mood_bubble")
		
		# 状态图标动画
		if data.status == "daydream":
			status_label.position.y = -50 + sin(t * 2) * 3
			mood_bubble.position.y = -35 + sin(t * 1.5) * 2
		elif data.status == "dozing":
			status_label.position.y = -50 + sin(t * 1) * 2
			mood_bubble.position.y = -35 + sin(t * 0.8) * 1
		else:
			status_label.position.y = -50
			mood_bubble.position.y = -35
		
		# 眼睛动画
		var eyes = student.get_node_or_null("Node2D")
		if eyes:
			var eye_type = eyes.get_meta("type", "focus")
			if eye_type == "daydream":
				# 眼睛向上看
				for child in eyes.get_children():
					child.position.y = eyes.get_meta("base_y", -5) - 2
			elif eye_type == "dozing":
				# 闭眼
				for child in eyes.get_children():
					child.visible = false
			else:
				for child in eyes.get_children():
					child.visible = true
					child.position.y = eyes.get_meta("base_y", -5)

func update_player_label():
	player_label.text = player_name

func _on_timer_timeout():
	update_time_display()
	update_class_display()

func update_time_display():
	var time_dict = Time.get_time_dict_from_system()
	var hour = str(time_dict.hour).pad_zeros(2)
	var minute = str(time_dict.minute).pad_zeros(2)
	time_label.text = "%s:%s" % [hour, minute]
	
	var date_dict = Time.get_date_dict_from_system()
	var months = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
	var days = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
	date_label.text = "%s年%s%s %s" % [date_dict.year, months[date_dict.month - 1], date_dict.day, days[date_dict.weekday]]

func update_class_display():
	# 根据当前时间确定课程
	var time_dict = Time.get_time_dict_from_system()
	var current_time_minutes = time_dict.hour * 60 + time_dict.minute
	
	# 找到当前课程
	var current_class_data = schedule_data[0]
	for i in range(schedule_data.size() - 1):
		var class_time = schedule_data[i]
		var next_class_time = schedule_data[i + 1]
		
		var class_minutes = int(class_time.time.split(":")[0]) * 60 + int(class_time.time.split(":")[1])
		var next_class_minutes = int(next_class_time.time.split(":")[0]) * 60 + int(next_class_time.time.split(":")[1])
		
		if current_time_minutes >= class_minutes and current_time_minutes < next_class_minutes:
			current_class_data = class_time
			break
	
	current_class = current_class_data
	
	if current_class_data.name == "午休" or current_class_data.name == "放学":
		class_info_label.text = "🏠 %s" % current_class_data.name
	else:
		class_info_label.text = "📚 %s - %s老师" % [current_class_data.name, current_class_data.teacher]

func show_student_info(student_node):
	var data = student_node.get_meta("data")
	var vbox = $UI/StatusPanel/VBox
	
	# 更新信息
	vbox.get_node("Name").text = data.name
	
	var quote_label = vbox.get_node("Quote")
	quote_label.text = "\"%s\"" % data.quote
	
	# 心情
	var mood_label = vbox.get_node("Mood")
	mood_label.text = get_mood_emoji(data.mood) + " " + get_mood_text(data.mood)
	mood_label.visible = true
	
	# 状态
	var status_text = ""
	match data.status:
		"focus": status_text = "📖 正在专注听课"
		"daydream": status_text = "🌸 正在发呆"
		"dozing": status_text = "💤 正在睡觉"
		"active": status_text = "✋ 积极发言"
	
	vbox.get_node("Status").text = status_text
	
	# 显示面板
	status_panel.visible = true
	
	# 定位到学生旁边
	var student_pos = student_node.position
	status_panel.position = Vector2(student_pos.x + 50, student_pos.y - 100)
	
	# 确保面板不超出屏幕
	if status_panel.position.x > 900:
		status_panel.position.x = student_pos.x - 250
	if status_panel.position.y < 100:
		status_panel.position.y = 100

func hide_student_info():
	status_panel.visible = false

func get_mood_text(mood):
	var texts = {
		"happy": "心情很好",
		"sad": "有点伤心",
		"excited": "很兴奋",
		"tired": "有点累",
		"confused": "困惑不解",
		"thinking": "在思考",
		"focused": "很专注",
		"studious": "爱学习",
		"bored": "无聊困倦",
		"relaxed": "很放松",
		"sleepy": "昏昏欲睡",
		"motivated": "动力十足",
		"helpful": "乐于助人",
		"hungry": "肚子饿了"
	}
	return texts.get(mood, "普通")

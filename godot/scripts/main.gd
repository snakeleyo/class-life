extends Node2D

# 学生数据
var students_data = [
	{"name": "张伟", "x": 150, "y": 380, "status": "focus", "color": Color(0.659, 0.831, 0.902), "quote": "今天也要加油！", "hair": Color(0.173, 0.243, 0.314)},
	{"name": "李娜", "x": 280, "y": 380, "status": "focus", "color": Color(1, 0.718, 0.769), "quote": "好想快点下课呀～", "hair": Color(0.545, 0.271, 0.075)},
	{"name": "王强", "x": 410, "y": 380, "status": "daydream", "color": Color(0.659, 0.831, 0.902), "quote": "窗外的小鸟...", "hair": Color(0.1, 0.1, 0.1)},
	{"name": "刘芳", "x": 540, "y": 380, "status": "focus", "color": Color(1, 0.718, 0.769), "quote": "这道题好难啊", "hair": Color(0.545, 0, 0)},
	{"name": "陈刚", "x": 670, "y": 380, "status": "active", "color": Color(0.659, 0.831, 0.902), "quote": "老师！我知道！", "hair": Color(0.29, 0.216, 0.157)},
	{"name": "赵敏", "x": 150, "y": 480, "status": "daydream", "color": Color(1, 0.718, 0.769), "quote": "中午吃什么呢", "hair": Color(0.824, 0.412, 0.118)},
	{"name": "孙杰", "x": 280, "y": 480, "status": "focus", "color": Color(0.659, 0.831, 0.902), "quote": "认真听讲中...", "hair": Color(0.184, 0.31, 0.31)},
	{"name": "周丽", "x": 410, "y": 480, "status": "dozing", "color": Color(1, 0.718, 0.769), "quote": "zzz...", "hair": Color(0.545, 0, 0.545)},
	{"name": "吴涛", "x": 540, "y": 480, "status": "focus", "color": Color(0.659, 0.831, 0.902), "quote": "笔记要做好", "hair": Color(0.333, 0.42, 0.184)},
	{"name": "郑雪", "x": 670, "y": 480, "status": "focus", "color": Color(1, 0.718, 0.769), "quote": "好困啊...", "hair": Color(1, 0.753, 0.796)},
	{"name": "钱程", "x": 150, "y": 580, "status": "focus", "color": Color(0.659, 0.831, 0.902), "quote": "考试加油！", "hair": Color(0.545, 0, 0.545)},
	{"name": "孙悦", "x": 280, "y": 580, "status": "active", "color": Color(1, 0.718, 0.769), "quote": "有人要借笔吗", "hair": Color(1, 0.388, 0.278)},
	{"name": "李龙", "x": 410, "y": 580, "status": "daydream", "color": Color(0.659, 0.831, 0.902), "quote": "放学去打球", "hair": Color(0, 0.392, 0)},
	{"name": "王燕", "x": 540, "y": 580, "status": "focus", "color": Color(1, 0.718, 0.769), "quote": "这道题我会！", "hair": Color(1, 0.078, 0.576)},
	{"name": "刘虎", "x": 670, "y": 580, "status": "focus", "color": Color(0.659, 0.831, 0.902), "quote": "肚子饿了...", "hair": Color(0.412, 0.412, 0.412)}
]

var student_nodes = []
var current_time = Time.get_time_dict_from_system()
var timer = 0.0

@onready var time_label = $UI/TopBar/TimeLabel
@onready var date_label = $UI/TopBar/DateLabel
@onready var status_panel = $UI/StatusPanel
@onready var player = $Player

# 状态图标
var status_icons = {
	"focus": "📖",
	"daydream": "🌸",
	"dozing": "💤",
	"active": "✋"
}

func _ready():
	# 创建学生节点
	create_students()
	# 更新时间显示
	update_time_display()
	
	# 创建定时器
	var time_timer = Timer.new()
	time_timer.wait_time = 1.0
	time_timer.timeout.connect(_on_time_timer_timeout)
	add_child(time_timer)
	time_timer.start()

func _process(delta):
	timer += delta
	# 更新学生动画
	update_student_animations()

func create_students():
	var students_container = $Classroom/Students
	
	for i in range(students_data.size()):
		var data = students_data[i]
		var student = Node2D.new()
		student.position = Vector2(data.x, data.y)
		student.set_meta("data", data)
		student.set_meta("index", i)
		
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
		
		# 名字标签
		var name_label = Label.new()
		name_label.text = data.name
		name_label.position = Vector2(-25, 30)
		name_label.add_theme_font_size_override("font_size", 14)
		name_label.add_theme_color_override("font_color", Color.WHITE)
		student.add_child(name_label)
		
		# 状态图标
		var status_label = Label.new()
		status_label.text = status_icons[data.status]
		status_label.position = Vector2(15, -45)
		status_label.add_theme_font_size_override("font_size", 20)
		student.add_child(status_label)
		student.set_meta("status_label", status_label)
		
		students_container.add_child(student)
		student_nodes.append(student)

func update_student_animations():
	var t = Time.get_ticks_msec() / 1000.0
	
	for student in student_nodes:
		var status = student.get_meta("data").status
		var status_label = student.get_meta("status_label")
		
		if status == "daydream":
			# 发呆时轻微浮动
			status_label.position.y = -45 + sin(t * 2) * 3
		elif status == "dozing":
			# 睡觉时更慢的浮动
			status_label.position.y = -45 + sin(t * 1.5) * 2

func _on_time_timer_timeout():
	update_time_display()

func update_time_display():
	var time_dict = Time.get_time_dict_from_system()
	var hour = str(time_dict.hour).pad_zeros(2)
	var minute = str(time_dict.minute).pad_zeros(2)
	time_label.text = "%s:%s" % [hour, minute]
	
	var date_dict = Time.get_date_dict_from_system()
	var months = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
	var days = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
	date_label.text = "%s年%s%s %s" % [date_dict.year, months[date_dict.month - 1], date_dict.day, days[date_dict.weekday]]

func show_student_info(student_node):
	var data = student_node.get_meta("data")
	var vbox = $UI/StatusPanel/VBox
	
	# 更新信息
	vbox.get_node("Name").text = data.name
	vbox.get_node("Quote").text = "\"%s\"" % data.quote
	
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
	status_panel.position = Vector2(student_pos.x + 30, student_pos.y - 80)

func hide_student_info():
	status_panel.visible = false

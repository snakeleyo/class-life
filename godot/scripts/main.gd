extends Node2D

var students = []
var anim_timer = 0.0
var font: Font
var schedule = [
	{"time": "08:30", "name": "Morning", "teacher": ""},
	{"time": "09:00", "name": "Chinese", "teacher": "Mr. Wang"},
	{"time": "10:00", "name": "Math", "teacher": "Mr. Zhang"},
	{"time": "11:00", "name": "English", "teacher": "Ms. Li"},
	{"time": "13:00", "name": "Lunch", "teacher": ""},
	{"time": "14:00", "name": "Physics", "teacher": "Mr. Zhao"},
	{"time": "15:00", "name": "Chemistry", "teacher": "Mr. Liu"},
	{"time": "16:00", "name": "Dismiss", "teacher": ""}
]

func _ready():
	font = ThemeDB.fallback_font
	students = [
		{"name": "Zhang Wei", "gx": 1, "gy": 2, "status": "focus", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.20, 0.25, 0.32)},
		{"name": "Li Na", "gx": 2, "gy": 2, "status": "focus", "body": Color(1.0, 0.75, 0.78), "hair": Color(0.55, 0.28, 0.10)},
		{"name": "Wang Qiang", "gx": 3, "gy": 2, "status": "daydream", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.15, 0.15, 0.15)},
		{"name": "Liu Fang", "gx": 4, "gy": 2, "status": "focus", "body": Color(1.0, 0.75, 0.78), "hair": Color(0.55, 0.05, 0.05)},
		{"name": "Chen Gang", "gx": 5, "gy": 2, "status": "active", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.30, 0.23, 0.18)},
		{"name": "Zhao Min", "gx": 1, "gy": 3, "status": "daydream", "body": Color(1.0, 0.75, 0.78), "hair": Color(0.82, 0.42, 0.15)},
		{"name": "Sun Jie", "gx": 2, "gy": 3, "status": "focus", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.20, 0.32, 0.32)},
		{"name": "Zhou Li", "gx": 3, "gy": 3, "status": "dozing", "body": Color(1.0, 0.75, 0.78), "hair": Color(0.55, 0.05, 0.55)},
		{"name": "Wu Tao", "gx": 4, "gy": 3, "status": "focus", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.35, 0.43, 0.20)},
		{"name": "Zheng Xue", "gx": 5, "gy": 3, "status": "focus", "body": Color(1.0, 0.75, 0.78), "hair": Color(1.0, 0.76, 0.82)},
		{"name": "Qian Cheng", "gx": 1, "gy": 4, "status": "focus", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.55, 0.05, 0.55)},
		{"name": "Sun Yue", "gx": 2, "gy": 4, "status": "active", "body": Color(1.0, 0.75, 0.78), "hair": Color(1.0, 0.40, 0.30)},
		{"name": "Li Long", "gx": 3, "gy": 4, "status": "daydream", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.05, 0.40, 0.05)},
		{"name": "Wang Yan", "gx": 4, "gy": 4, "status": "focus", "body": Color(1.0, 0.75, 0.78), "hair": Color(1.0, 0.10, 0.60)},
		{"name": "Liu Hu", "gx": 5, "gy": 4, "status": "focus", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.42, 0.42, 0.42)}
	]
	update_time()

func _process(delta):
	anim_timer += delta
	queue_redraw()

func _draw():
	draw_room()

func to_iso(x, y):
	return Vector2((x - y) * 50 + 640, (x + y) * 25 + 150)

func draw_room():
	# 地板
	for y in range(6):
		for x in range(6):
			var p1 = to_iso(x, y)
			var p2 = to_iso(x + 1, y)
			var p3 = to_iso(x + 1, y + 1)
			var p4 = to_iso(x, y + 1)
			var c = Color(0.8, 0.68, 0.5) if (x + y) % 2 == 0 else Color(0.75, 0.62, 0.45)
			draw_polygon(PackedVector2Array([p1, p2, p3, p4]), [c])
	
	# 墙壁
	draw_rect(Rect2(0, 0, 1280, 180), Color(0.92, 0.89, 0.84))
	draw_line(Vector2(0, 180), Vector2(1280, 180), Color(0.7, 0.65, 0.55), 3)
	
	# 黑板
	var bp = to_iso(3, 0.5)
	draw_rect(Rect2(bp.x - 150, bp.y - 60, 300, 100), Color(0.2, 0.3, 0.25))
	draw_rect(Rect2(bp.x - 155, bp.y - 65, 310, 110), Color(0.5, 0.32, 0.1), false, 4)
	draw_string(font, Vector2(bp.x - 40, bp.y - 20), "MATH", HORIZONTAL_ALIGNMENT_CENTER, -1, 28, Color(0.96, 0.96, 0.86))
	draw_string(font, Vector2(bp.x - 50, bp.y + 20), "Mr. Zhang", HORIZONTAL_ALIGNMENT_CENTER, -1, 16, Color(0.8, 0.9, 0.8))
	
	# 窗户
	for i in range(3):
		var wp = to_iso(0.5 + i * 2, 0.3)
		draw_rect(Rect2(wp.x - 40, wp.y - 50, 80, 90), Color(0.55, 0.8, 0.9))
		draw_rect(Rect2(wp.x - 45, wp.y - 55, 90, 100), Color(0.95, 0.95, 0.93), false, 3)
	
	# 讲台
	var pp = to_iso(3.5, 1.8)
	draw_rect(Rect2(pp.x - 40, pp.y - 15, 80, 30), Color(0.6, 0.35, 0.1))
	
	# 学生
	var sorted = students.duplicate()
	sorted.sort_custom(func(a, b): return a.gy < b.gy)
	for s in sorted:
		draw_student(s)

func draw_student(s):
	var pos = to_iso(s.gx, s.gy)
	
	# 阴影
	draw_ellipse(pos + Vector2(0, 15), Vector2(18, 8), Color(0, 0, 0, 0.25))
	# 身体
	draw_ellipse(pos, Vector2(16, 22), s.body)
	# 头发
	draw_ellipse(pos + Vector2(0, -18), Vector2(14, 10), s.hair)
	# 眼睛
	draw_rect(Rect2(pos.x - 6, pos.y - 5, 4, 4), Color(0.1, 0.1, 0.1))
	draw_rect(Rect2(pos.x + 2, pos.y - 5, 4, 4), Color(0.1, 0.1, 0.1))
	# 名字
	draw_string(font, Vector2(pos.x - 20, pos.y + 35), s.name, HORIZONTAL_ALIGNMENT_CENTER, -1, 12, Color.WHITE)
	# 状态
	var status_y = pos.y - 35 + sin(anim_timer * 2) * 2
	draw_string(font, Vector2(pos.x + 10, status_y), "*", HORIZONTAL_ALIGNMENT_CENTER, -1, 14)

func draw_ellipse(center, size, color):
	var pts = PackedVector2Array()
	for i in range(32):
		var angle = i * TAU / 32
		pts.append(center + Vector2(cos(angle) * size.x, sin(angle) * size.y))
	draw_polygon(pts, [color])

func update_time():
	var t = Time.get_time_dict_from_system()
	$UI/TopBar/TimeLabel.text = "%02d:%02d" % [t.hour, t.minute]
	var d = Time.get_date_dict_from_system()
	var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	$UI/TopBar/DateLabel.text = "%s %d, %d %s" % [months[d.month-1], d.day, d.year, days[d.weekday]]
	var mins = t.hour * 60 + t.minute
	var cur = schedule[0]
	for i in range(schedule.size() - 1):
		var t1 = schedule[i].time.split(":")
		var t2 = schedule[i + 1].time.split(":")
		var m1 = int(t1[0]) * 60 + int(t1[1])
		var m2 = int(t2[0]) * 60 + int(t2[1])
		if mins >= m1 and mins < m2:
			cur = schedule[i]
			break
	$UI/TopBar/ClassInfo.text = cur.name + " - " + cur.teacher
	$UI/TopBar/OnlineCount.text = "%d students" % students.size()

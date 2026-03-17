extends Node2D

# 2.5D 等距视角教室 - 纯绘制版本

var students = []
var anim_timer = 0.0
var font: Font

# 颜色
var c_wall = Color(0.91, 0.88, 0.84)
var c_floor = Color(0.78, 0.65, 0.45)
var c_floor_line = Color(0.6, 0.5, 0.35, 0.3)
var c_blackboard = Color(0.18, 0.28, 0.22)
var c_board_frame = Color(0.45, 0.28, 0.08)
var c_window = Color(0.55, 0.80, 0.92)
var c_window_frame = Color(0.95, 0.95, 0.93)
var c_curtain = Color(0.80, 0.20, 0.20, 0.85)
var c_podium = Color(0.55, 0.30, 0.08)

var schedule = [
	{"time": "08:30", "name": "早读", "teacher": ""},
	{"time": "09:00", "name": "语文", "teacher": "王老师"},
	{"time": "10:00", "name": "数学", "teacher": "张老师"},
	{"time": "11:00", "name": "英语", "teacher": "李老师"},
	{"time": "13:00", "name": "午休", "teacher": ""},
	{"time": "14:00", "name": "物理", "teacher": "赵老师"},
	{"time": "15:00", "name": "化学", "teacher": "刘老师"},
	{"time": "16:00", "name": "放学", "teacher": ""}
]

func _ready():
	# 初始化学生数据
	students = [
		{"name": "张伟", "gx": 1, "gy": 2, "status": "focus", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.17, 0.24, 0.31), "mood": "happy"},
		{"name": "李娜", "gx": 2, "gy": 2, "status": "focus", "body": Color(1, 0.72, 0.77), "hair": Color(0.55, 0.27, 0.08), "mood": "bored"},
		{"name": "王强", "gx": 3, "gy": 2, "status": "daydream", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.10, 0.10, 0.10), "mood": "relaxed"},
		{"name": "刘芳", "gx": 4, "gy": 2, "status": "focus", "body": Color(1, 0.72, 0.77), "hair": Color(0.55, 0.0, 0.0), "mood": "confused"},
		{"name": "陈刚", "gx": 5, "gy": 2, "status": "active", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.29, 0.22, 0.16), "mood": "excited"},
		{"name": "赵敏", "gx": 1, "gy": 3, "status": "daydream", "body": Color(1, 0.72, 0.77), "hair": Color(0.82, 0.41, 0.12), "mood": "thinking"},
		{"name": "孙杰", "gx": 2, "gy": 3, "status": "focus", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.18, 0.31, 0.31), "mood": "focused"},
		{"name": "周丽", "gx": 3, "gy": 3, "status": "dozing", "body": Color(1, 0.72, 0.77), "hair": Color(0.55, 0.0, 0.55), "mood": "sleepy"},
		{"name": "吴涛", "gx": 4, "gy": 3, "status": "focus", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.33, 0.42, 0.18), "mood": "studious"},
		{"name": "郑雪", "gx": 5, "gy": 3, "status": "focus", "body": Color(1, 0.72, 0.77), "hair": Color(1.0, 0.75, 0.80), "mood": "tired"},
		{"name": "钱程", "gx": 1, "gy": 4, "status": "focus", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.55, 0.0, 0.55), "mood": "motivated"},
		{"name": "孙悦", "gx": 2, "gy": 4, "status": "active", "body": Color(1, 0.72, 0.77), "hair": Color(1.0, 0.39, 0.28), "mood": "helpful"},
		{"name": "李龙", "gx": 3, "gy": 4, "status": "daydream", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.0, 0.39, 0.0), "mood": "excited"},
		{"name": "王燕", "gx": 4, "gy": 4, "status": "focus", "body": Color(1, 0.72, 0.77), "hair": Color(1.0, 0.08, 0.58), "mood": "happy"},
		{"name": "刘虎", "gx": 5, "gy": 4, "status": "focus", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.41, 0.41, 0.41), "mood": "hungry"}
	]
	
	font = ThemeDB.fallback_font
	update_time()

func _process(delta):
	anim_timer += delta
	queue_redraw()

func _draw():
	draw_isometric_classroom()

# 等距投影转换
func iso_to_screen(gx, gy, gz = 0):
	var tile_w = 64.0
	var tile_h = 32.0
	var screen_x = (gx - gy) * tile_w + 640
	var screen_y = (gx + gy) * tile_h * 0.5 + 200 - gz * 40
	return Vector2(screen_x, screen_y)

func draw_isometric_classroom():
	# 地板 - 等距菱形网格
	for y in range(8):
		for x in range(8):
			var p = iso_to_screen(x, y)
			var pts = PackedVector2Array([
				iso_to_screen(x, y),
				iso_to_screen(x + 1, y),
				iso_to_screen(x + 1, y + 1),
				iso_to_screen(x, y + 1)
			])
			if (x + y) % 2 == 0:
				draw_polygon(pts, [c_floor])
			else:
				draw_polygon(pts, [c_floor.lightened(0.05)])
	
	# 墙壁
	var wall_pts = PackedVector2Array([
		Vector2(0, 200), Vector2(1280, 200), Vector2(1280, 0), Vector2(0, 0)
	])
	draw_polygon(wall_pts, [c_wall])
	
	# 墙底线
	draw_line(Vector2(0, 200), Vector2(1280, 200), Color(0.7, 0.65, 0.55), 3.0)
	
	# 黑板
	draw_isometric_blackboard()
	
	# 讲台
	draw_isometric_podium()
	
	# 窗户
	draw_isometric_windows()
	
	# 学生
	draw_isometric_students()

func draw_isometric_blackboard():
	var bx = 3.0
	var by = 0.5
	var bw = 3.0
	var bh = 1.5
	
	var pts = PackedVector2Array([
		iso_to_screen(bx, by),
		iso_to_screen(bx + bw, by),
		iso_to_screen(bx + bw, by + bh),
		iso_to_screen(bx, by + bh)
	])
	draw_polygon(pts, [c_blackboard])
	
	# 边框
	draw_polyline(pts, c_board_frame, 4.0)
	draw_polyline(pts + Vector2(pts[0]), c_board_frame, 4.0)
	
	# 文字
	var center = iso_to_screen(bx + bw/2, by + bh/2)
	draw_string(font, Vector2(center.x - 50, center.y - 10), "Math", HORIZONTAL_ALIGNMENT_CENTER, -1, 32, Color(0.96, 0.96, 0.86))
	draw_string(font, Vector2(center.x - 60, center.y + 20), "Mr. Zhang", HORIZONTAL_ALIGNMENT_CENTER, -1, 18, Color(0.78, 0.88, 0.78))

func draw_isometric_podium():
	var px = 3.5
	var py = 1.8
	var pw = 1.5
	var ph = 0.6
	
	var pts = PackedVector2Array([
		iso_to_screen(px, py),
		iso_to_screen(px + pw, py),
		iso_to_screen(px + pw, py + ph),
		iso_to_screen(px, py + ph)
	])
	draw_polygon(pts, [c_podium])

func draw_isometric_windows():
	for i in range(3):
		var wx = 0.5 + i * 2.0
		var wy = 0.3
		var ww = 1.2
		var wh = 1.8
		
		# 窗框
		var frame_pts = PackedVector2Array([
			iso_to_screen(wx - 0.1, wy - 0.1),
			iso_to_screen(wx + ww + 0.1, wy - 0.1),
			iso_to_screen(wx + ww + 0.1, wy + wh + 0.1),
			iso_to_screen(wx - 0.1, wy + wh + 0.1)
		])
		draw_polygon(frame_pts, [c_window_frame])
		
		# 窗户
		var pts = PackedVector2Array([
			iso_to_screen(wx, wy),
			iso_to_screen(wx + ww, wy),
			iso_to_screen(wx + ww, wy + wh),
			iso_to_screen(wx, wy + wh)
		])
		draw_polygon(pts, [c_window])
		
		# 窗帘
		var curtain_pts = PackedVector2Array([
			iso_to_screen(wx, wy),
			iso_to_screen(wx + 0.3, wy),
			iso_to_screen(wx + 0.25, wy + wh * 0.7),
			iso_to_screen(wx, wy + wh * 0.8)
		])
		draw_polygon(curtain_pts, [c_curtain])

func draw_isometric_students():
	# 按 Y 排序，实现遮挡关系
	var sorted_students = students.duplicate()
	sorted_students.sort_custom(func(a, b): return a.gy < b.gy)
	
	for s in sorted_students:
		draw_isometric_student(s)

func draw_isometric_student(s):
	var pos = iso_to_screen(s.gx, s.gy)
	
	# 阴影
	var shadow_pts = PackedVector2Array([
		pos + Vector2(-15, 5),
		pos + Vector2(15, 5),
		pos + Vector2(20, 15),
		pos + Vector2(-20, 15)
	])
	draw_polygon(shadow_pts, [Color(0, 0, 0, 0.25)])
	
	# 身体 - 等距椭圆效果
	var body_pts = PackedVector2Array([
		pos + Vector2(-14, -25),
		pos + Vector2(14, -25),
		pos + Vector2(16, 0),
		pos + Vector2(14, 20),
		pos + Vector2(-14, 20),
		pos + Vector2(-16, 0)
	])
	draw_polygon(body_pts, [s.body])
	
	# 头发
	var hair_pts = PackedVector2Array([
		pos + Vector2(-15, -22),
		pos + Vector2(15, -22),
		pos + Vector2(14, -8),
		pos + Vector2(-14, -8)
	])
	draw_polygon(hair_pts, [s.hair])
	
	# 眼睛
	draw_rect(Rect2(pos.x - 7, pos.y - 5, 4, 4), Color(0.15, 0.15, 0.15))
	draw_rect(Rect2(pos.x + 3, pos.y - 5, 4, 4), Color(0.15, 0.15, 0.15))
	
	# 腮红
	if s.mood == "happy" or s.mood == "excited":
		draw_rect(Rect2(pos.x - 12, pos.y + 2, 5, 3), Color(1, 0.6, 0.6, 0.5))
		draw_rect(Rect2(pos.x + 7, pos.y + 2, 5, 3), Color(1, 0.6, 0.6, 0.5))
	
	# 名字
	draw_string(font, Vector2(pos.x - 15, pos.y + 32), s.name, HORIZONTAL_ALIGNMENT_CENTER, -1, 13, Color.WHITE)
	
	# 状态图标
	var status_y = pos.y - 42
	if s.status == "daydream":
		status_y += sin(anim_timer * 2.5) * 3
	elif s.status == "dozing":
		status_y += sin(anim_timer * 1.5) * 2
	
	var status_icon = get_status_icon(s.status)
	draw_string(font, Vector2(pos.x + 12, status_y), status_icon, HORIZONTAL_ALIGNMENT_CENTER, -1, 18)
	
	# 心情
	var mood_icon = get_mood_icon(s.mood)
	draw_string(font, Vector2(pos.x - 22, pos.y - 35), mood_icon, HORIZONTAL_ALIGNMENT_CENTER, -1, 14)

func get_status_icon(status):
	var m = {"focus": "[F]", "daydream": "[D]", "dozing": "[Z]", "active": "[Q]"}
	return m.get(status, "[F]")

func get_mood_icon(mood):
	var m = {
		"happy": ":)", "sad": ":(", "excited": ":D", "tired": ":|",
		"confused": ":S", "thinking": ":? ", "focused": ":)", "studious": ":]",
		"bored": "-_-", "relaxed": ":)", "sleepy": "zZ", "motivated": "!!",
		"helpful": ":)", "hungry": "(:"
	}
	return m.get(mood, ":)")

func update_time():
	var now = Time.get_time_dict_from_system()
	$UI/TopBar/TimeLabel.text = "%02d:%02d" % [now.hour, now.minute]
	
	var date = Time.get_date_dict_from_system()
	var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	$UI/TopBar/DateLabel.text = "%s %d, %d %s" % [months[date.month - 1], date.day, date.year, days[date.weekday]]
	
	# 课程
	var current_minutes = now.hour * 60 + now.minute
	var current_class = schedule[0]
	for i in range(schedule.size() - 1):
		var t1 = schedule[i].time.split(":")
		var t2 = schedule[i + 1].time.split(":")
		var m1 = int(t1[0]) * 60 + int(t1[1])
		var m2 = int(t2[0]) * 60 + int(t2[1])
		if current_minutes >= m1 and current_minutes < m2:
			current_class = schedule[i]
			break
	
	if current_class.name == "午休" or current_class.name == "放学":
		$UI/TopBar/ClassInfo.text = "[Home] " + current_class.name
	else:
		$UI/TopBar/ClassInfo.text = "[Book] " + current_class.name + " - " + current_class.teacher
	
	$UI/TopBar/OnlineCount.text = "[User] %d online" % students.size()

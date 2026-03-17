extends Node2D

# 纯 2.5D 等距视角教室 - 放置类游戏

var students = [
	{"name": "张伟", "gx": 1, "gy": 2, "status": "focus", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.17, 0.24, 0.31), "mood": "happy"},
	{"name": "李娜", "gx": 2, "gy": 2, "status": "focus", "body": Color(1, 0.72, 0.77), "hair": Color(0.55, 0.27, 0.08), "mood": "bored"},
	{"name": "王强", "gx": 3, "gy": 2, "status": "daydream", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.1, 0.1, 0.1), "mood": "relaxed"},
	{"name": "刘芳", "gx": 4, "gy": 2, "status": "focus", "body": Color(1, 0.72, 0.77), "hair": Color(0.55, 0, 0), "mood": "confused"},
	{"name": "陈刚", "gx": 5, "gy": 2, "status": "active", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.29, 0.22, 0.16), "mood": "excited"},
	{"name": "赵敏", "gx": 1, "gy": 3, "status": "daydream", "body": Color(1, 0.72, 0.77), "hair": Color(0.82, 0.41, 0.12), "mood": "thinking"},
	{"name": "孙杰", "gx": 2, "gy": 3, "status": "focus", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.18, 0.31, 0.31), "mood": "focused"},
	{"name": "周丽", "gx": 3, "gy": 3, "status": "dozing", "body": Color(1, 0.72, 0.77), "hair": Color(0.55, 0, 0.55), "mood": "sleepy"},
	{"name": "吴涛", "gx": 4, "gy": 3, "status": "focus", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.33, 0.42, 0.18), "mood": "studious"},
	{"name": "郑雪", "gx": 5, "gy": 3, "status": "focus", "body": Color(1, 0.72, 0.77), "hair": Color(1, 0.75, 0.80), "mood": "tired"},
	{"name": "钱程", "gx": 1, "gy": 4, "status": "focus", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.55, 0, 0.55), "mood": "motivated"},
	{"name": "孙悦", "gx": 2, "gy": 4, "status": "active", "body": Color(1, 0.72, 0.77), "hair": Color(1, 0.39, 0.28), "mood": "helpful"},
	{"name": "李龙", "gx": 3, "gy": 4, "status": "daydream", "body": Color(0.66, 0.83, 0.90), "hair": Color(0, 0.39, 0), "mood": "excited"},
	{"name": "王燕", "gx": 4, "gy": 4, "status": "focus", "body": Color(1, 0.72, 0.77), "hair": Color(1, 0.08, 0.58), "mood": "happy"},
	{"name": "刘虎", "gx": 5, "gy": 4, "status": "focus", "body": Color(0.66, 0.83, 0.90), "hair": Color(0.41, 0.41, 0.41), "mood": "hungry"}
]

var anim_timer = 0.0
var font: Font

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
	font = ThemeDB.fallback_font
	update_time()

func _process(delta):
	anim_timer += delta
	queue_redraw()

func _draw():
	draw_classroom()
	draw_students()

func grid_to_iso(gx, gy):
	var tile_w = 70
	var tile_h = 35
	var x = (gx - gy) * tile_w + 640
	var y = (gx + gy) * tile_h + 180
	return Vector2(x, y)

func draw_classroom():
	# 墙壁
	draw_rect(Rect2(0, 0, 1280, 350), Color(0.88, 0.85, 0.80))
	# 地板
	draw_rect(Rect2(0, 350, 1280, 370), Color(0.75, 0.62, 0.45))
	# 地板线
	for i in range(8):
		draw_line(Vector2(0, 350 + i * 40), Vector2(1280, 350 + i * 40), Color(0.6, 0.5, 0.38, 0.3), 1.0)
	
	# 黑板
	draw_rect(Rect2(340, 80, 600, 180), Color(0.18, 0.28, 0.22))
	draw_rect(Rect2(335, 75, 610, 190), Color(0.45, 0.28, 0.08), false, 4)
	
	# 黑板文字
	draw_string(font, Vector2(520, 160), "数  学", HORIZONTAL_ALIGNMENT_CENTER, -1, 48, Color(0.96, 0.96, 0.86))
	draw_string(font, Vector2(580, 210), "—— 张老师 ——", HORIZONTAL_ALIGNMENT_CENTER, -1, 22, Color(0.78, 0.88, 0.78))
	
	# 讲台
	var podium_pts = PackedVector2Array([Vector2(560, 340), Vector2(720, 340), Vector2(740, 400), Vector2(540, 400)])
	draw_polygon(podium_pts, [Color(0.50, 0.28, 0.06)])
	
	# 窗户
	for i in range(3):
		var wx = 150 + i * 400
		draw_rect(Rect2(wx - 10, 50, 140, 200), Color(0.90, 0.90, 0.88))
		draw_rect(Rect2(wx, 60, 120, 180), Color(0.50, 0.75, 0.88))
		# 窗帘
		var c1 = PackedVector2Array([Vector2(wx, 60), Vector2(wx + 35, 60), Vector2(wx + 30, 180), Vector2(wx, 200)])
		var c2 = PackedVector2Array([Vector2(wx + 120, 60), Vector2(wx + 85, 60), Vector2(wx + 90, 180), Vector2(wx + 120, 200)])
		draw_polygon(c1, [Color(0.75, 0.15, 0.15, 0.8)])
		draw_polygon(c2, [Color(0.75, 0.15, 0.15, 0.8)])

func draw_students():
	for s in students:
		var pos = grid_to_iso(s.gx, s.gy)
		
		# 阴影
		var shadow = PackedVector2Array([pos + Vector2(-18, 10), pos + Vector2(18, 10), pos + Vector2(22, 20), pos + Vector2(-22, 20)])
		draw_polygon(shadow, [Color(0, 0, 0, 0.2)])
		
		# 身体
		var body = PackedVector2Array([pos + Vector2(-16, -28), pos + Vector2(16, -28), pos + Vector2(18, 0), pos + Vector2(16, 22), pos + Vector2(-16, 22), pos + Vector2(-18, 0)])
		draw_polygon(body, [s.body])
		
		# 头发
		var hair = PackedVector2Array([pos + Vector2(-16, -24), pos + Vector2(16, -24), pos + Vector2(14, -8), pos + Vector2(-14, -8)])
		draw_polygon(hair, [s.hair])
		
		# 眼睛
		draw_rect(Rect2(pos.x - 8, pos.y - 5, 5, 5), Color(0.15, 0.15, 0.15))
		draw_rect(Rect2(pos.x + 3, pos.y - 5, 5, 5), Color(0.15, 0.15, 0.15))
		
		# 腮红
		if s.mood == "happy" or s.mood == "excited":
			draw_rect(Rect2(pos.x - 14, pos.y + 3, 6, 4), Color(1, 0.6, 0.6, 0.5))
			draw_rect(Rect2(pos.x + 8, pos.y + 3, 6, 4), Color(1, 0.6, 0.6, 0.5))
		
		# 名字
		draw_string(font, Vector2(pos.x - 15, pos.y + 35), s.name, HORIZONTAL_ALIGNMENT_CENTER, -1, 14, Color.WHITE)
		
		# 状态
		var status_y = pos.y - 45
		if s.status == "daydream":
			status_y += sin(anim_timer * 2) * 2
		draw_string(font, Vector2(pos.x + 15, status_y), get_status_icon(s.status), HORIZONTAL_ALIGNMENT_CENTER, -1, 20)
		
		# 心情
		draw_string(font, Vector2(pos.x - 25, pos.y - 38), get_mood_icon(s.mood), HORIZONTAL_ALIGNMENT_CENTER, -1, 16)

func get_status_icon(status):
	var m = {"focus": "📖", "daydream": "🌸", "dozing": "💤", "active": "✋"}
	return m.get(status, "📖")

func get_mood_icon(mood):
	var m = {
		"happy": "😊", "sad": "😢", "excited": "🤩", "tired": "😫",
		"confused": "😕", "thinking": "🤔", "focused": "🙂", "studious": "📚",
		"bored": "😴", "relaxed": "😌", "sleepy": "😪", "motivated": "💪",
		"helpful": "🤝", "hungry": "🍚"
	}
	return m.get(mood, "😐")

func update_time():
	var now = Time.get_time_dict_from_system()
	$UI/TopBar/TimeLabel.text = "%02d:%02d" % [now.hour, now.minute]
	
	var date = Time.get_date_dict_from_system()
	var months = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
	var days = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
	$UI/TopBar/DateLabel.text = "%d年%s%d日 %s" % [date.year, months[date.month - 1], date.day, days[date.weekday]]
	
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
		$UI/TopBar/ClassInfo.text = "🏠 " + current_class.name
	else:
		$UI/TopBar/ClassInfo.text = "📚 " + current_class.name + " - " + current_class.teacher + "老师"
	
	$UI/TopBar/OnlineCount.text = "👥 %d人在线" % students.size()

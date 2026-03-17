extends Node2D

var students = []
var anim_timer = 0.0
var font: Font

var c_wall = Color(0.92, 0.89, 0.84)
var c_floor1 = Color(0.82, 0.70, 0.52)
var c_floor2 = Color(0.78, 0.65, 0.48)
var c_blackboard = Color(0.20, 0.32, 0.25)
var c_board_frame = Color(0.50, 0.32, 0.12)
var c_window = Color(0.60, 0.85, 0.95)
var c_window_frame = Color(0.96, 0.96, 0.94)
var c_curtain = Color(0.85, 0.22, 0.22)
var c_podium = Color(0.60, 0.35, 0.12)
var c_shadow = Color(0, 0, 0, 0.3)

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
	students = [
		{"name": "Zhang Wei", "gx": 1, "gy": 2, "status": "focus", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.20, 0.25, 0.32), "mood": "happy"},
		{"name": "Li Na", "gx": 2, "gy": 2, "status": "focus", "body": Color(1.0, 0.75, 0.78), "hair": Color(0.55, 0.28, 0.10), "mood": "neutral"},
		{"name": "Wang Qiang", "gx": 3, "gy": 2, "status": "daydream", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.15, 0.15, 0.15), "mood": "relaxed"},
		{"name": "Liu Fang", "gx": 4, "gy": 2, "status": "focus", "body": Color(1.0, 0.75, 0.78), "hair": Color(0.55, 0.05, 0.05), "mood": "thinking"},
		{"name": "Chen Gang", "gx": 5, "gy": 2, "status": "active", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.30, 0.23, 0.18), "mood": "excited"},
		{"name": "Zhao Min", "gx": 1, "gy": 3, "status": "daydream", "body": Color(1.0, 0.75, 0.78), "hair": Color(0.82, 0.42, 0.15), "mood": "thinking"},
		{"name": "Sun Jie", "gx": 2, "gy": 3, "status": "focus", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.20, 0.32, 0.32), "mood": "focused"},
		{"name": "Zhou Li", "gx": 3, "gy": 3, "status": "dozing", "body": Color(1.0, 0.75, 0.78), "hair": Color(0.55, 0.05, 0.55), "mood": "sleepy"},
		{"name": "Wu Tao", "gx": 4, "gy": 3, "status": "focus", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.35, 0.43, 0.20), "mood": "studious"},
		{"name": "Zheng Xue", "gx": 5, "gy": 3, "status": "focus", "body": Color(1.0, 0.75, 0.78), "hair": Color(1.0, 0.76, 0.82), "mood": "tired"},
		{"name": "Qian Cheng", "gx": 1, "gy": 4, "status": "focus", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.55, 0.05, 0.55), "mood": "motivated"},
		{"name": "Sun Yue", "gx": 2, "gy": 4, "status": "active", "body": Color(1.0, 0.75, 0.78), "hair": Color(1.0, 0.40, 0.30), "mood": "helpful"},
		{"name": "Li Long", "gx": 3, "gy": 4, "status": "daydream", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.05, 0.40, 0.05), "mood": "excited"},
		{"name": "Wang Yan", "gx": 4, "gy": 4, "status": "focus", "body": Color(1.0, 0.75, 0.78), "hair": Color(1.0, 0.10, 0.60), "mood": "happy"},
		{"name": "Liu Hu", "gx": 5, "gy": 4, "status": "focus", "body": Color(0.70, 0.85, 0.92), "hair": Color(0.42, 0.42, 0.42), "mood": "neutral"}
	]
	font = ThemeDB.fallback_font
	update_time()

func _process(delta):
	anim_timer += delta
	queue_redraw()

func _draw():
	draw_classroom()

func to_iso(gx, gy, gz = 0.0):
	var TW = 56.0
	var TH = 28.0
	var x = (gx - gy) * TW + 640.0
	var y = (gx + gy) * TH + 180.0 - gz * 35.0
	return Vector2(x, y)

func draw_classroom():
	draw_floor()
	draw_wall()
	draw_windows()
	draw_blackboard()
	draw_podium()
	draw_students()

func draw_floor():
	for y in range(7):
		for x in range(7):
			var pts = PackedVector2Array([
				to_iso(x, y), to_iso(x+1, y), to_iso(x+1, y+1), to_iso(x, y+1)
			])
			var c = c_floor1 if (x+y)%2 == 0 else c_floor2
			draw_polygon(pts, [c])

func draw_wall():
	draw_polygon(PackedVector2Array([Vector2(0,180), Vector2(1280,180), Vector2(1280,0), Vector2(0,0)]), [c_wall])
	draw_line(Vector2(0,180), Vector2(1280,180), Color(0.7,0.65,0.55), 2)

func draw_windows():
	for i in range(3):
		var wx = 0.3 + i * 2.0
		var wy = 0.2
		var ww = 1.3
		var wh = 1.6
		var pts = PackedVector2Array([to_iso(wx,wy), to_iso(wx+ww,wy), to_iso(wx+ww,wy+wh), to_iso(wx,wy+wh)])
		draw_polygon(pts, [c_window_frame])
		var inner = PackedVector2Array([to_iso(wx+0.1,wy+0.1), to_iso(wx+ww-0.1,wy+0.1), to_iso(wx+ww-0.1,wy+wh-0.1), to_iso(wx+0.1,wy+wh-0.1)])
		draw_polygon(inner, [c_window])
		draw_polygon(PackedVector2Array([to_iso(wx,wy), to_iso(wx+0.3,wy), to_iso(wx+0.25,wy+wh*0.6), to_iso(wx,wy+wh*0.7)]), [c_curtain])
		draw_polygon(PackedVector2Array([to_iso(wx+ww,wy), to_iso(wx+ww-0.3,wy), to_iso(wx+ww-0.25,wy+wh*0.6), to_iso(wx+ww,wy+wh*0.7)]), [c_curtain])

func draw_blackboard():
	var bx, by = 2.5, 0.4
	var bw, bh = 3.2, 1.4
	var pts = PackedVector2Array([to_iso(bx,by), to_iso(bx+bw,by), to_iso(bx+bw,by+bh), to_iso(bx,by+bh)])
	draw_polygon(pts, [c_blackboard])
	draw_polyline(pts, c_board_frame, 3)
	var center = to_iso(bx+bw/2, by+bh/2)
	draw_string(font, Vector2(center.x-40, center.y-8), "MATH", HORIZONTAL_ALIGNMENT_CENTER, -1, 28, Color(0.96,0.96,0.88))
	draw_string(font, Vector2(center.x-50, center.y+16), "Mr. Zhang", HORIZONTAL_ALIGNMENT_CENTER, -1, 16, Color(0.80,0.90,0.80))

func draw_podium():
	var px, py = 3.3, 1.6
	var pw, ph = 1.4, 0.5
	var pts = PackedVector2Array([to_iso(px,py), to_iso(px+pw,py), to_iso(px+pw,py+ph), to_iso(px,py+ph)])
	draw_polygon(pts, [c_podium])

func draw_students():
	var sorted = students.duplicate()
	sorted.sort_custom(func(a, b): return a.gy < b.gy)
	for s in sorted:
		var pos = to_iso(s.gx, s.gy)
		draw_polygon(PackedVector2Array([pos+Vector2(-14,4), pos+Vector2(14,4), pos+Vector2(18,14), pos+Vector2(-18,14)]), [c_shadow])
		draw_polygon(PackedVector2Array([pos+Vector2(-12,-22), pos+Vector2(12,-22), pos+Vector2(14,0), pos+Vector2(12,18), pos+Vector2(-12,18), pos+Vector2(-14,0)]), [s.body])
		draw_polygon(PackedVector2Array([pos+Vector2(-12,-20), pos+Vector2(12,-20), pos+Vector2(10,-6), pos+Vector2(-10,-6)]), [s.hair])
		draw_rect(Rect2(pos.x-6, pos.y-4, 3, 3), Color(0.12,0.12,0.12))
		draw_rect(Rect2(pos.x+3, pos.y-4, 3, 3), Color(0.12,0.12,0.12))
		if s.mood == "happy" or s.mood == "excited":
			draw_rect(Rect2(pos.x-10, pos.y+2, 4, 2), Color(1,0.6,0.6,0.5))
			draw_rect(Rect2(pos.x+6, pos.y+2, 4, 2), Color(1,0.6,0.6,0.5))
		draw_string(font, Vector2(pos.x-18, pos.y+28), s.name, HORIZONTAL_ALIGNMENT_CENTER, -1, 11, Color.WHITE)
		var sy = pos.y - 38 + (sin(anim_timer*2.5)*2 if s.status=="daydream" else (sin(anim_timer*1.5)*1 if s.status=="dozing" else 0))
		draw_string(font, Vector2(pos.x+8, sy), get_status(s.status), HORIZONTAL_ALIGNMENT_CENTER, -1, 14)
		draw_string(font, Vector2(pos.x-18, sy+3), get_mood(s.mood), HORIZONTAL_ALIGNMENT_CENTER, -1, 11)

func get_status(st):
	var m = {"focus": "*", "daydream": "~", "dozing": "z", "active": "!"}
	return m.get(st, "*")

func get_mood(m):
	var mm = {"happy": ":)", "neutral": ":|", "excited": ":D", "tired": "-_-", "thinking": ":?", "relaxed": ":)", "focused": ":]", "studious": "[:", "sleepy": "Z", "motivated": "!!", "helpful": ":)"}
	return mm.get(m, ":)")

func update_time():
	var t = Time.get_time_dict_from_system()
	$UI/TopBar/TimeLabel.text = "%02d:%02d" % [t.hour, t.minute]
	var d = Time.get_date_dict_from_system()
	var months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
	var days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
	$UI/TopBar/DateLabel.text = "%s %d, %d %s" % [months[d.month-1], d.day, d.year, days[d.weekday]]
	var mins = t.hour * 60 + t.minute
	var cur = schedule[0]
	for i in range(schedule.size()-1):
		var t1 = schedule[i].time.split(":")
		var t2 = schedule[i+1].time.split(":")
		var m1 = int(t1[0])*60 + int(t1[1])
		var m2 = int(t2[0])*60 + int(t2[1])
		if mins >= m1 and mins < m2:
			cur = schedule[i]
			break
	$UI/TopBar/ClassInfo.text = ("[H] " if cur.name=="Lunch" or cur.name=="Dismiss" else "[B] ") + cur.name + " - " + cur.teacher
	$UI/TopBar/OnlineCount.text = "[U] %d online" % students.size()

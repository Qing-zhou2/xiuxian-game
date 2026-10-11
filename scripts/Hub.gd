extends Node2D

# 修炼区：展示永久资源、结算结果，买丹药/服用，按 E 进入副本
# 丹药链路（灵石 → 丹药 → 属性）见 docs/DEV_LOG.md 决策 20-21

var _info: Label
var _pill: Label
var _bonus: Label
var _last: Label
var _hint: Label
var _msg: Label
var _msg_timer: Timer


func _ready() -> void:
	_setup_ui()
	GameManager.currency_changed.connect(_on_currency_changed)
	GameManager.pills_changed.connect(_on_pills_changed)
	_update_ui()


func _setup_ui() -> void:
	var canvas := CanvasLayer.new()
	add_child(canvas)

	var title := Label.new()
	title.text = "修炼区"
	title.position = Vector2(600, 200)
	title.add_theme_font_size_override("font_size", 48)
	canvas.add_child(title)

	_info = Label.new()
	_info.position = Vector2(600, 280)
	_info.add_theme_font_size_override("font_size", 24)
	canvas.add_child(_info)

	_pill = Label.new()
	_pill.position = Vector2(600, 320)
	_pill.add_theme_font_size_override("font_size", 24)
	canvas.add_child(_pill)

	_bonus = Label.new()
	_bonus.position = Vector2(600, 360)
	_bonus.add_theme_font_size_override("font_size", 20)
	canvas.add_child(_bonus)

	_last = Label.new()
	_last.position = Vector2(600, 400)
	_last.add_theme_font_size_override("font_size", 18)
	canvas.add_child(_last)

	_hint = Label.new()
	_hint.position = Vector2(600, 460)
	_hint.add_theme_font_size_override("font_size", 20)
	canvas.add_child(_hint)

	_msg = Label.new()
	_msg.position = Vector2(600, 520)
	_msg.add_theme_font_size_override("font_size", 18)
	_msg.visible = false
	canvas.add_child(_msg)

	_msg_timer = Timer.new()
	_msg_timer.one_shot = true
	_msg_timer.wait_time = 1.6
	add_child(_msg_timer)
	_msg_timer.timeout.connect(_clear_msg)


func _update_ui() -> void:
	_info.text = "境界：" + GameManager.realm_name() + "   灵石：" + str(GameManager.spirit_stones)
	var def := GameManager.pill_def("attack")
	_pill.text = str(def.get("name", "")) + "：" + str(GameManager.pill_count("attack"))
	_bonus.text = "攻击加成：+" + str(GameManager.get_attr_bonus("attack_damage"))
	_last.text = _last_run_text()
	_hint.text = "E 进副本 · B 买" + str(def.get("name", "")) + "(" + str(def.get("price", 0)) + ") · C 服用(攻击+" + str(def.get("amount", 0)) + ")"


func _last_run_text() -> String:
	if not RunManager.has_run:
		return "尚未进入副本"
	if RunManager.last_run_success:
		return "上次结算：撤离成功 +" + str(RunManager.last_run_gain) + " 灵石"
	return "上次结算：死亡，保留 " + str(RunManager.last_run_gain) + " 灵石"


func _show_msg(text: String) -> void:
	_msg.text = text
	_msg.visible = true
	_msg_timer.start()


func _clear_msg() -> void:
	_msg.visible = false


func _on_currency_changed(_amount: int) -> void:
	_update_ui()


func _on_pills_changed(_count: int) -> void:
	_update_ui()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	match event.keycode:
		KEY_E:
			get_tree().change_scene_to_file("res://scenes/Dungeon.tscn")
		KEY_B:
			if GameManager.buy_pill("attack"):
				_show_msg("购买成功")
			else:
				_show_msg("灵石不足，无法购买")
		KEY_C:
			if GameManager.consume_pill("attack"):
				var amount := int(GameManager.pill_def("attack").get("amount", 0))
				_show_msg("服用成功，攻击 +" + str(amount))
			else:
				_show_msg("没有可服用的丹药")

extends Node2D

# 主场景：生成玩家、敌人，维护 HUD

const PlayerScript := preload("res://scripts/Player.gd")
const EnemyScript := preload("res://scripts/Enemy.gd")

var player
var hud_realm: Label
var hud_stones: Label
var hud_hint: Label


func _ready() -> void:
	_spawn_player()
	_setup_hud()
	GameManager.realm_changed.connect(_on_realm_changed)
	GameManager.currency_changed.connect(_on_currency_changed)
	# 定时刷怪
	var timer := Timer.new()
	timer.wait_time = 1.5
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_spawn_enemy)
	# 开局先来几个
	for i in 3:
		_spawn_enemy()
	_update_hud()


func _spawn_player() -> void:
	player = PlayerScript.new()
	add_child(player)
	player.add_to_group("player")
	player.global_position = Vector2(640, 360)
	player.health_changed.connect(_on_health_changed)


func _spawn_enemy() -> void:
	var enemy = EnemyScript.new()
	add_child(enemy)
	enemy.player = player
	enemy.global_position = _random_spawn_pos()


func _random_spawn_pos() -> Vector2:
	match randi() % 4:
		0: return Vector2(randf_range(40, 1240), 40)
		1: return Vector2(randf_range(40, 1240), 680)
		2: return Vector2(40, randf_range(40, 680))
		3: return Vector2(1240, randf_range(40, 680))
	return Vector2(640, 360)


func _setup_hud() -> void:
	var canvas := CanvasLayer.new()
	add_child(canvas)
	hud_realm = Label.new()
	hud_realm.position = Vector2(16, 12)
	hud_realm.add_theme_font_size_override("font_size", 24)
	canvas.add_child(hud_realm)
	hud_stones = Label.new()
	hud_stones.position = Vector2(16, 44)
	hud_stones.add_theme_font_size_override("font_size", 20)
	canvas.add_child(hud_stones)
	hud_hint = Label.new()
	hud_hint.position = Vector2(16, 660)
	hud_hint.add_theme_font_size_override("font_size", 16)
	canvas.add_child(hud_hint)


func _update_hud() -> void:
	hud_realm.text = "境界：" + GameManager.realm_name()
	var cost := GameManager.next_cost()
	var cost_text := "已到顶" if cost < 0 else str(cost)
	hud_stones.text = "灵石：" + str(GameManager.spirit_stones) + "   /   下一境界需 " + cost_text
	hud_hint.text = "WASD 移动 · 鼠标瞄准 + 左键攻击 · 按 B 突破"


func _on_realm_changed(_new_realm: int) -> void:
	_update_hud()


func _on_currency_changed(_amount: int) -> void:
	_update_hud()


func _on_health_changed(_hp: int) -> void:
	pass  # 后续加血条 UI


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_B:
		if GameManager.try_breakthrough():
			_update_hud()

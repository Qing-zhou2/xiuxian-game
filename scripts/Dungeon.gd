extends Node2D

# 副本：出生点、敌人、战斗、拾取（临时收益）、固定出口、死亡结算
# 撤离/死亡统一走 RunManager.settle() 后返回修炼区

const PlayerScript := preload("res://scripts/Player.gd")
const EnemyScript := preload("res://scripts/Enemy.gd")

const SPAWN_POS := Vector2(640, 120)   # 玩家出生点
const EXIT_POS := Vector2(640, 600)    # 固定撤离出口
const ENEMY_COUNT := 5                 # 本局敌人数量（M1 固定一批，不做刷新）

var player
var hud_hp: Label
var hud_stones: Label
var hud_hint: Label
var _run_ended := false


func _ready() -> void:
	RunManager.reset()   # 进副本清空单局临时状态
	_setup_exit()
	_spawn_player()
	_setup_hud()
	for i in ENEMY_COUNT:
		_spawn_enemy()
	RunManager.temp_stones_changed.connect(_on_temp_stones_changed)
	_update_hud()


func _setup_exit() -> void:
	var exit_area := Area2D.new()
	exit_area.collision_layer = 0
	exit_area.collision_mask = 1  # 检测玩家层
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 36.0
	shape.shape = circle
	exit_area.add_child(shape)
	exit_area.position = EXIT_POS
	add_child(exit_area)
	exit_area.body_entered.connect(_on_exit_entered)


func _spawn_player() -> void:
	player = PlayerScript.new()
	add_child(player)
	player.add_to_group("player")
	player.global_position = SPAWN_POS
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

	hud_hp = Label.new()
	hud_hp.position = Vector2(16, 12)
	hud_hp.add_theme_font_size_override("font_size", 24)
	canvas.add_child(hud_hp)

	hud_stones = Label.new()
	hud_stones.position = Vector2(16, 44)
	hud_stones.add_theme_font_size_override("font_size", 20)
	canvas.add_child(hud_stones)

	hud_hint = Label.new()
	hud_hint.position = Vector2(16, 660)
	hud_hint.add_theme_font_size_override("font_size", 16)
	canvas.add_child(hud_hint)

	# 出口标记（占位文字，后续换正式出口素材）
	var exit_label := Label.new()
	exit_label.text = "【出口】"
	exit_label.position = EXIT_POS - Vector2(30, 20)
	exit_label.add_theme_font_size_override("font_size", 20)
	canvas.add_child(exit_label)


func _update_hud() -> void:
	if player == null or not is_instance_valid(player):
		return
	hud_hp.text = "生命：" + str(player.hp) + "/" + str(player.max_hp)
	hud_stones.text = "本局灵石：" + str(RunManager.temp_stones)
	hud_hint.text = "WASD 移动 · J 普攻 · 走到【出口】撤离"


func _on_temp_stones_changed(_amount: int) -> void:
	_update_hud()


func _on_health_changed(hp: int) -> void:
	_update_hud()
	if hp <= 0:
		_end_run(false)


func _on_exit_entered(body: Node) -> void:
	if body == player:
		_end_run(true)


func _end_run(success: bool) -> void:
	if _run_ended:
		return
	_run_ended = true
	RunManager.settle(success)
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Hub.tscn")

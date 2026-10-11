extends CharacterBody2D

# 玩家：WASD 移动 + J 普攻，朝向用「最后方向记忆」（不鼠标瞄准）
# 决策见 docs/DEV_LOG.md 与 docs/GAME_DESIGN.md
# 美术素材：assets/player.png（覆盖同名文件即可换图）

signal health_changed(hp: int)

const GameConfig := preload("res://data/game_config.gd")
const SlashScript := preload("res://scripts/Slash.gd")
const PLAYER_TEXTURE := preload("res://assets/player.png")

const MOVE_SPEED := GameConfig.PLAYER_MOVE_SPEED
const ATTACK_COOLDOWN := GameConfig.PLAYER_ATTACK_COOLDOWN
const ATTACK_RANGE := GameConfig.PLAYER_ATTACK_RANGE   # 刀气出生点相对玩家的偏移距离

var max_hp := GameConfig.PLAYER_MAX_HP
var hp := GameConfig.PLAYER_MAX_HP
var attack_damage := GameConfig.PLAYER_ATTACK_DAMAGE  # 基础值，_ready 叠加永久加成

# 朝向：最后一次非零移动方向，默认朝右
var facing := Vector2.RIGHT

var _attack_timer := 0.0


func _ready() -> void:
	attack_damage += GameManager.get_attr_bonus("attack_damage")  # 叠加永久攻击加成
	collision_layer = 1
	collision_mask = 0
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 16.0
	shape.shape = circle
	add_child(shape)
	var sprite := Sprite2D.new()
	sprite.texture = PLAYER_TEXTURE
	add_child(sprite)


func _physics_process(delta: float) -> void:
	var dir := Vector2.ZERO
	if Input.is_key_pressed(KEY_W): dir.y -= 1
	if Input.is_key_pressed(KEY_S): dir.y += 1
	if Input.is_key_pressed(KEY_A): dir.x -= 1
	if Input.is_key_pressed(KEY_D): dir.x += 1
	if dir != Vector2.ZERO:
		facing = dir.normalized()
	velocity = dir.normalized() * MOVE_SPEED
	move_and_slide()
	position = position.clamp(Vector2(20, 20), Vector2(1260, 700))
	_attack_timer = max(0.0, _attack_timer - delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_J and event.pressed and not event.echo:
		attack()


func attack() -> void:
	if _attack_timer > 0.0:
		return
	_attack_timer = ATTACK_COOLDOWN
	var slash = SlashScript.new()
	slash.damage = attack_damage
	get_parent().add_child(slash)
	slash.global_position = global_position + facing * ATTACK_RANGE
	slash.rotation = facing.angle()


func take_damage(dmg: int) -> void:
	hp -= dmg
	health_changed.emit(hp)
	if hp <= 0:
		queue_free()

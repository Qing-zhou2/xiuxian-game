extends CharacterBody2D

# 玩家：WASD 移动 + 鼠标瞄准 + 左键刀攻（火）
# 手动瞄准攻击（哈迪斯式），见 docs/GDD.md
# 美术素材：assets/player.png（覆盖同名文件即可换图）

signal health_changed(hp: int)

const SlashScript := preload("res://scripts/Slash.gd")
const PLAYER_TEXTURE := preload("res://assets/player.png")

const MOVE_SPEED := 260.0
const ATTACK_COOLDOWN := 0.3

var max_hp := 100
var hp := 100
var attack_damage := 10

var _attack_timer := 0.0


func _ready() -> void:
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
	velocity = dir.normalized() * MOVE_SPEED
	move_and_slide()
	position = position.clamp(Vector2(20, 20), Vector2(1260, 700))
	_attack_timer = max(0.0, _attack_timer - delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		attack()


func attack() -> void:
	if _attack_timer > 0.0:
		return
	_attack_timer = ATTACK_COOLDOWN
	var aim := (get_global_mouse_position() - global_position).normalized()
	var slash = SlashScript.new()
	slash.damage = attack_damage
	get_parent().add_child(slash)
	slash.global_position = global_position + aim * 40.0
	slash.rotation = aim.angle()


func take_damage(dmg: int) -> void:
	hp -= dmg
	health_changed.emit(hp)
	if hp <= 0:
		queue_free()

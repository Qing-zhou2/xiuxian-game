extends CharacterBody2D

# 敌人：简单追击 AI（MVP 用代码，后续换 LimboAI 行为树）
# 美术素材：assets/enemy.png（覆盖同名文件即可换图）

const GameConfig := preload("res://data/game_config.gd")
const DropScript := preload("res://scripts/Drop.gd")
const ENEMY_TEXTURE := preload("res://assets/enemy.png")

const MOVE_SPEED := GameConfig.ENEMY_MOVE_SPEED
const ATTACK_DAMAGE := GameConfig.ENEMY_ATTACK_DAMAGE
const ATTACK_INTERVAL := GameConfig.ENEMY_ATTACK_INTERVAL
const CONTACT_RANGE := 30.0   # 接触伤害判定距离（MVP 用距离，后续换 Area2D）

var hp := GameConfig.ENEMY_MAX_HP
var spirit_stone_value := GameConfig.ENEMY_SPIRIT_STONE_VALUE
var player: Node2D
var _attack_timer := 0.0


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 13.0
	shape.shape = circle
	add_child(shape)
	var sprite := Sprite2D.new()
	sprite.texture = ENEMY_TEXTURE
	add_child(sprite)


func _physics_process(delta: float) -> void:
	if player == null or not is_instance_valid(player):
		return
	var dir := (player.global_position - global_position).normalized()
	velocity = dir * MOVE_SPEED
	move_and_slide()
	_attack_timer = max(0.0, _attack_timer - delta)
	# 接触伤害：靠近玩家时按间隔造成伤害（MVP 用距离判定，后续可换 Area2D 攻击判定）
	if _attack_timer <= 0.0 and global_position.distance_to(player.global_position) < CONTACT_RANGE:
		_attack_timer = ATTACK_INTERVAL
		if player.has_method("take_damage"):
			player.take_damage(ATTACK_DAMAGE)


func take_damage(dmg: int) -> void:
	hp -= dmg
	if hp <= 0:
		die()


func die() -> void:
	# 掉落灵石，等玩家走上去采集
	# 用 call_deferred 延后挂到场景树，避免在物理回调里改碰撞状态报错
	var drop := DropScript.new()
	drop.value = spirit_stone_value
	drop.position = position
	get_parent().call_deferred("add_child", drop)
	queue_free()

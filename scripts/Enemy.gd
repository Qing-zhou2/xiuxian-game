extends CharacterBody2D

# 敌人：简单追击 AI（MVP 用代码，后续换 LimboAI 行为树）
# 美术素材：assets/enemy.png（覆盖同名文件即可换图）

const DropScript := preload("res://scripts/Drop.gd")
const ENEMY_TEXTURE := preload("res://assets/enemy.png")

const MOVE_SPEED := 90.0

var hp := 30
var spirit_stone_value := 3
var player: Node2D


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


func _physics_process(_delta: float) -> void:
	if player == null or not is_instance_valid(player):
		return
	var dir := (player.global_position - global_position).normalized()
	velocity = dir * MOVE_SPEED
	move_and_slide()


func take_damage(dmg: int) -> void:
	hp -= dmg
	if hp <= 0:
		die()


func die() -> void:
	# 掉落灵石，等玩家走上去采集
	var drop = DropScript.new()
	drop.value = spirit_stone_value
	get_parent().add_child(drop)
	drop.global_position = global_position
	queue_free()

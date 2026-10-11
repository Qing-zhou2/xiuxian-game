extends Area2D

# 掉落物：灵石，玩家走上去采集
# 美术素材：assets/spirit_stone.png（覆盖同名文件即可换图）

const DROP_TEXTURE := preload("res://assets/spirit_stone.png")

var value := 3
var _taken := false


func _ready() -> void:
	collision_layer = 4
	collision_mask = 1  # 检测玩家层
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 10.0
	shape.shape = circle
	add_child(shape)
	var sprite := Sprite2D.new()
	sprite.texture = DROP_TEXTURE
	add_child(sprite)
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if _taken:
		return
	if body.is_in_group("player"):
		_taken = true
		RunManager.add_temp_stones(value)
		queue_free()

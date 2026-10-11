extends Area2D

# 刀气攻击判定：短暂存在的 Area2D，命中敌人造成伤害
# 美术素材：assets/slash.png（覆盖同名文件即可换图）

const SLASH_TEXTURE := preload("res://assets/slash.png")

var damage := 10


func _ready() -> void:
	collision_layer = 0
	collision_mask = 2  # 检测敌人层
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(60, 26)
	shape.shape = rect
	add_child(shape)
	var sprite := Sprite2D.new()
	sprite.texture = SLASH_TEXTURE
	add_child(sprite)
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(0.12).timeout.connect(func(): queue_free())


func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

extends Area2D

# 刀气攻击判定：短暂存在的 Area2D，命中敌人造成伤害
# 视觉：16 帧动画刀气 assets/vfx/slash.png（替换此文件即可换特效）
# 来源：AutoSprite "Shadow Slash"，CC0，见 assets/vfx/LICENSES.md

const SLASH_SHEET := preload("res://assets/vfx/slash.png")

const FRAME_SIZE := 256
const GRID := 4          # 4×4 = 16 帧
const SCALE := 0.3       # 256px 缩到约 77px
const FPS := 96.0        # 16 帧约 0.17 秒播完

var damage := 10


func _ready() -> void:
	collision_layer = 0
	collision_mask = 2  # 检测敌人层

	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(FRAME_SIZE * SCALE, FRAME_SIZE * SCALE * 0.55)
	shape.shape = rect
	add_child(shape)

	var sprite := _build_sprite()
	add_child(sprite)
	sprite.animation_finished.connect(func(): queue_free())

	body_entered.connect(_on_body_entered)


func _build_sprite() -> AnimatedSprite2D:
	var sprite := AnimatedSprite2D.new()
	var frames := SpriteFrames.new()
	frames.add_animation("slash")
	frames.set_animation_loop("slash", false)
	frames.set_animation_speed("slash", FPS)
	for row in range(GRID):
		for col in range(GRID):
			var atlas := AtlasTexture.new()
			atlas.atlas = SLASH_SHEET
			atlas.region = Rect2(col * FRAME_SIZE, row * FRAME_SIZE, FRAME_SIZE, FRAME_SIZE)
			frames.add_frame("slash", atlas)
	sprite.sprite_frames = frames
	sprite.animation = "slash"
	sprite.scale = Vector2(SCALE, SCALE)
	sprite.play()
	return sprite


func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

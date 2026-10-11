extends SceneTree

# 一次性开发工具：生成占位贴图到 assets/，供后续替换为正式美术素材
# 运行：godot --headless --path . --script res://tools/generate_placeholders.gd

func _init() -> void:
	var specs := {
		"player.png": [32, 32, Color(0.95, 0.35, 0.15, 1.0)],       # 主角（红）
		"enemy.png": [26, 26, Color(0.5, 0.3, 0.6, 1.0)],           # 妖兽（紫）
		"spirit_stone.png": [16, 16, Color(0.6, 0.9, 1.0, 1.0)],    # 灵石（淡蓝）
		"slash.png": [60, 26, Color(1.0, 0.6, 0.2, 0.7)],           # 刀气（橙，半透明）
	}
	for filename in specs:
		var spec: Array = specs[filename]
		var img := Image.create(spec[0], spec[1], false, Image.FORMAT_RGBA8)
		img.fill(spec[2])
		var err := img.save_png("res://assets/" + filename)
		print("已生成 ", filename, " (err=", err, ")")
	quit()

# 美术素材替换约定

## 原则
代码里不画图、不硬编码颜色，所有视觉素材用 Sprite2D / AnimatedSprite2D 加载 `assets/` 下的贴图。
**替换素材 = 用同名 PNG 覆盖文件，代码零改动。**

## 素材清单
| 文件 | 用途 | 当前素材 |
|---|---|---|
| `assets/player.png` | 主角 | 32×32 红色方块（占位，待换） |
| `assets/enemy.png` | 妖兽 | 26×26 紫色方块（占位，待换） |
| `assets/spirit_stone.png` | 灵石掉落 | 16×16 淡蓝方块（占位，待换） |
| `assets/vfx/slash.png` | 刀气攻击（16 帧动画） | AutoSprite Shadow Slash，CC0 |
| `assets/vfx/fireball.png` | 火球特效（16 帧动画，待接入） | AutoSprite Fireball，CC0 |
| `assets/vfx/particles/` | 火焰/火花粒子（待接入） | Kenney Particle Pack，CC0 |

特效素材来源与许可见 `assets/vfx/LICENSES.md`。

## 替换方法
1. 画出正式素材（PNG，建议透明背景；尺寸可大于占位图，Godot 会自动用）
2. 覆盖 `assets/` 下同名文件
3. 运行游戏即生效

## 后续扩展
- 动画：把 Sprite2D 换成 AnimatedSprite2D + SpriteFrames，帧图放 `assets/vfx/`（刀气已这样做）
- 音频：`assets/audio/` 下放 .ogg / .wav
- 特效：优先用 Godot 内置 GPUParticles2D / shader，或直接放贴图进 `assets/vfx/particles/`

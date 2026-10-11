# 修仙动作游戏

俯视角动作游戏：主角选择灵根属性与功法，进副本打怪采集，攒资源突破境界（练气→筑基→金丹→元婴），再挑战更难副本。

## 技术栈
- 引擎：Godot 4.x
- 语言：GDScript
- 目标平台：Windows 桌面

## 铁律（AI 必须遵守）
1. 数值、资源名称、境界配置全部集中在 `data/`（.tres 或单独配置脚本），禁止硬编码进场景/脚本。
2. 遵循 Godot 官方 GDScript 风格：类名 PascalCase，变量/函数 snake_case，信号用过去式动词。
3. 玩家、敌人、掉落物用「场景 + 脚本」组织，数据用 Resource(.tres) 配置。
4. 视觉素材一律用 Sprite2D 加载 `assets/` 下的贴图，禁止在代码里硬编码颜色/画图形；替换素材见 docs/assets.md。

## 目录结构
- scenes/   场景（菜单、副本、UI）
- scripts/  脚本
- data/     数值与名称配置（.tres）
- autoload/ 全局单例
- assets/   素材（贴图、音频）
- tools/    开发用一次性脚本（如生成占位图）
- docs/     设计/架构文档

## 当前阶段
MVP 只做：火属性 + 刀类法宝。开局选灵根/功法先留接口，界面后做。详见 docs/GDD.md

## 开发注意事项
- 用脚本/文件系统直接新增 assets/ 下的贴图后，必须先跑 `godot --headless --import --path .` 导入，否则运行时报 "no resource loaders"。

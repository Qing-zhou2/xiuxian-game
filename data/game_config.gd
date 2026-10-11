extends RefCounted

# 全局数值与名称配置（铁律 #1：集中在 data/，禁止散落硬编码）
# 当前用配置脚本；后续如需在 Godot 编辑器里可视化编辑，可迁移到 .tres Resource。

# ---- 玩家（基础值；永久成长加成由 GameManager 叠加）----
const PLAYER_MAX_HP := 100
const PLAYER_ATTACK_DAMAGE := 10
const PLAYER_MOVE_SPEED := 260.0
const PLAYER_ATTACK_COOLDOWN := 0.3
const PLAYER_ATTACK_RANGE := 40.0

# ---- 敌人 ----
const ENEMY_MAX_HP := 30
const ENEMY_MOVE_SPEED := 90.0
const ENEMY_SPIRIT_STONE_VALUE := 3
const ENEMY_ATTACK_DAMAGE := 5
const ENEMY_ATTACK_INTERVAL := 1.0

# ---- 境界（序号 0=练气 1=筑基 2=金丹 3=元婴）----
const REALM_NAMES := ["练气", "筑基", "金丹", "元婴"]
const BREAKTHROUGH_COST := [0, 10, 40, 150]

# ---- 副本结算 ----
const FAILURE_RETENTION := 0.5  # 死亡失败时普通资源保留比例（下取整）

# ---- 丹药（成长消耗品）----
# 每种丹药一条配置；未来新增丹药 = 在数组里加一条，不改逻辑。
const PILLS := [
    {
        "id": "attack",
        "name": "淬体丹",
        "price": 20,              # 灵石价格
        "attr": "attack_damage",  # 提升的属性键
        "amount": 5,              # 每次服用的提升量
    },
]

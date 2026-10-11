# 技术架构文档

## 全局单例（Autoload）
- GameManager：当前境界、灵石数、玩家状态
- SaveManager：存档读写（JSON）

## 场景结构
- MainMenu.tscn  主菜单（后续放选灵根/功法）
- Dungeon.tscn   副本场景（战斗）
- HUD.tscn       血条/灵石/境界 UI

## 核心脚本
- Player.gd  移动(WASD) + 鼠标瞄准刀攻击（手动，火）
- Slash.gd   刀气攻击判定（Area2D）
- Enemy.gd   敌人（MVP 用简单追击，后续换 LimboAI 行为树）
- Drop.gd    掉落物（灵石，走上去采集）

## 数据驱动（关键）
- data/ 下 .tres 存：境界数值、资源名称、敌人属性
- 改数值/名称只改 .tres，不动代码

## 信号约定
- realm_changed(new_realm)      境界突破
- currency_changed(amount)      灵石变化

## 存档 schema（JSON）
{
  "realm": 0,            // 境界序号 0=练气 1=筑基 2=金丹 3=元婴
  "spirit_stones": 0,    // 灵石
  "linggen": "fire",     // 灵根
  "gongfa": "blade"      // 功法
}

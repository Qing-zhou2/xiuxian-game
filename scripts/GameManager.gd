extends Node

# 全局状态：境界 + 灵石
# 名称/数值集中在这里，改名字或数值只动这一处（数据驱动）

signal realm_changed(new_realm: int)
signal currency_changed(amount: int)
signal pills_changed(count: int)

const GameConfig := preload("res://data/game_config.gd")

# 境界配置（序号 0=练气 1=筑基 2=金丹 3=元婴）
const REALM_NAMES := GameConfig.REALM_NAMES
# 突破到下一境界所需灵石（初版占位，后续平衡，见 docs/GAME_DESIGN.md）
const BREAKTHROUGH_COST := GameConfig.BREAKTHROUGH_COST

var realm := 0
var spirit_stones := 0
var pills := {}        # 丹药持有数：id -> 数量
var attr_bonus := {}   # 永久属性加成：属性键 -> 数值


func add_spirit_stones(n: int) -> void:
	spirit_stones += n
	currency_changed.emit(spirit_stones)


func can_breakthrough() -> bool:
	return realm < REALM_NAMES.size() - 1 and spirit_stones >= BREAKTHROUGH_COST[realm + 1]


func try_breakthrough() -> bool:
	if not can_breakthrough():
		return false
	spirit_stones -= BREAKTHROUGH_COST[realm + 1]
	realm += 1
	realm_changed.emit(realm)
	currency_changed.emit(spirit_stones)
	return true


func realm_name() -> String:
	return REALM_NAMES[realm]


func next_cost() -> int:
	if realm >= REALM_NAMES.size() - 1:
		return -1
	return BREAKTHROUGH_COST[realm + 1]


# ---- 丹药（成长消耗品：灵石 → 丹药 → 属性）----

func pill_def(id: String) -> Dictionary:
	for p in GameConfig.PILLS:
		if p["id"] == id:
			return p
	return {}


func pill_count(id: String) -> int:
	return int(pills.get(id, 0))


func get_attr_bonus(attr: String) -> int:
	return int(attr_bonus.get(attr, 0))


func buy_pill(id: String) -> bool:
	var def := pill_def(id)
	if def.is_empty() or spirit_stones < int(def["price"]):
		return false
	spirit_stones -= int(def["price"])
	pills[id] = pill_count(id) + 1
	currency_changed.emit(spirit_stones)
	pills_changed.emit(pill_count(id))
	return true


func consume_pill(id: String) -> bool:
	var def := pill_def(id)
	if def.is_empty() or pill_count(id) <= 0:
		return false
	pills[id] = pill_count(id) - 1
	var attr := str(def["attr"])
	attr_bonus[attr] = get_attr_bonus(attr) + int(def["amount"])
	pills_changed.emit(pill_count(id))
	return true

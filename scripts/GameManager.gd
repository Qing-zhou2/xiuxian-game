extends Node

# 全局状态：境界 + 灵石
# 名称/数值集中在这里，改名字或数值只动这一处（数据驱动）

signal realm_changed(new_realm: int)
signal currency_changed(amount: int)

# 境界配置（序号 0=练气 1=筑基 2=金丹 3=元婴）
const REALM_NAMES := ["练气", "筑基", "金丹", "元婴"]
# 突破到下一境界所需灵石（初版占位，后续平衡，见 docs/GDD.md）
const BREAKTHROUGH_COST := [0, 10, 40, 150]

var realm := 0
var spirit_stones := 0


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

extends Node

# 单局状态：临时收益 + 结算防重复（与永久资源分离）
# 进副本 RunManager.reset()；撤离/死亡 RunManager.settle() 只结算一次

signal temp_stones_changed(amount: int)

const GameConfig := preload("res://data/game_config.gd")

var temp_stones := 0
var settled := false
var has_run := false          # 是否已完成过至少一局（供修炼区显示结算结果）
var last_run_success := false # 上一局是否撤离成功
var last_run_gain := 0        # 上一局入账的永久灵石


func reset() -> void:
	temp_stones = 0
	settled = false


func add_temp_stones(n: int) -> void:
	temp_stones += n
	temp_stones_changed.emit(temp_stones)


func settle(success: bool) -> int:
	# 统一结算：成功全额、失败按比例保留；只执行一次，返回入账的永久灵石
	if settled:
		return 0
	settled = true
	var keep := temp_stones
	if not success:
		keep = int(temp_stones * GameConfig.FAILURE_RETENTION)  # 下取整
	GameManager.add_spirit_stones(keep)
	temp_stones = 0
	has_run = true
	last_run_success = success
	last_run_gain = keep
	return keep

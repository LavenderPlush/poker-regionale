extends Node3D
class_name TableManager

@onready var players = $Players

var active_player_ids: Array[int] = []
var player_chips: Dictionary = {}
var table_chips: Dictionary = {}

var current_bet: int = 0


func fold(player_id: int) -> void:
	active_player_ids.remove_at(active_player_ids.find(player_id))


func raise(player_id: int, amount: int) -> void:
	current_bet += amount
	bet(player_id, amount)


func check(_player_id: int) -> void:
	pass


func call_bet(player_id: int) -> void:
	var difference = current_bet - table_chips[player_id]
	
	bet(player_id, difference)


func bet(player_id: int, amount: int) -> void:
	assert(player_chips[player_id] <= amount)
	
	player_chips[player_id] -= amount
	table_chips[player_id] += amount

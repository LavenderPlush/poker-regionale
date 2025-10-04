extends Node3D
class_name TableManager

@export var table_visual: TableVisual

var player_chips: Dictionary = {}
var table_chips: Dictionary = {}

var cards_on_table: Array = []

var current_bet: int = 0

@onready var deck: Deck = Deck.new()

func turn_cards(_amount: int) -> void:
	for i in range(_amount):
		var card = deck.draw()
		cards_on_table.append(card)
		table_visual.show_card(card)
		
func evaluate_score(hand: Array):
	var all_cards = hand.duplicate()
	all_cards.append_array(cards_on_table)
	
	
	
	

func fold(_player_id: int) -> void:
	# active_player_ids.remove_at(active_player_ids.find(player_id))
	pass


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

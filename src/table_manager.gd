extends Node3D
class_name TableManager

@export var table_visual: TableVisual

signal player_folded(id: int)
signal player_raised(id: int)

@export var starting_money: int = 100

var player_chips: Dictionary = {}
var table_chips: Dictionary = {}

var cards_on_table: Array = []

var current_bet: int = 0

var all_in: bool = false

@onready var deck: Deck = Deck.new()

func add_player(id: int):
	player_chips[id] = starting_money
	table_chips[id] = 0

func turn_cards(_amount: int) -> void:
	for i in range(_amount):
		var card = deck.draw()
		cards_on_table.append(card)
		table_visual.show_card(card)

func reset_table() -> void:
	table_visual.reset_cards()
	cards_on_table = []
	current_bet = 0
	all_in = false
		
func evaluate_score(hand: Array) -> int:
	var all_cards = hand.duplicate()
	all_cards.append_array(cards_on_table)
	var bing = Scoring.new(all_cards)
	return bing.score

func move_winnings(player: int) -> void:
	for k in table_chips.keys():
		player_chips[player] += table_chips[k]
		table_chips[k] = 0

func fold(_player_id: int) -> void:
	player_folded.emit(_player_id)


func raise(player_id: int, amount: int) -> void:
	player_raised.emit(player_id)
	current_bet += amount
	bet(player_id, amount)


func check(_player_id: int) -> void:
	pass


func call_bet(player_id: int) -> void:
	if all_in:
		bet(player_id, player_chips[player_id])
	else:
		var difference = current_bet - table_chips[player_id]
		bet(player_id, difference)


func bet(player_id: int, amount: int) -> void:
	var _players_chips = player_chips[player_id]
	assert(_players_chips >= amount)
	if amount == _players_chips:
		all_in = true
	
	player_chips[player_id] -= amount
	table_chips[player_id] += amount

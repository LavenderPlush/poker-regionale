extends Node3D

@export var hand_size: int = 2

@onready var table_manager: TableManager = $TableManager
@onready var players = $Players.get_children()

var player_turn: int = 0

var big_blind_player: int = 0
var big_blind_amount: int = 5

var player_raised: int = -1

var phase: int = 0

func _ready() -> void:
	for player in players:
		player.end_turn.connect(_on_end_turn)

func _new_round() -> void:
	_evaluate_players()
	big_blind_player = (big_blind_player + 1)
	if big_blind_player >= players.size():
		big_blind_player = big_blind_player % players.size()
	table_manager.deck = Deck.new()
	_distribute_cards()
	
func _evaluate_players():
	var players_to_remove = []
	for player in players:
		var money = table_manager.player_chips[player.id]
		if money <= 0:
			players_to_remove.append(player)
	for player in players_to_remove:
		players.remove_at(players.find(player))
		if player.id <= big_blind_player:
			big_blind_player -= 1

func _distribute_cards():
	for player in players:
		player.draw_cards(hand_size)
		
func _next_phase():
	match phase:
		0: table_manager.turn_cards(3)
		1: table_manager.turn_cards(1)
		2: table_manager.turn_cards(1)
		3:
			var hearts = 0
			for card in table_manager.cards_on_table:
				if card.suit == Card.Suits.HEART:
					hearts += 1
				elif card.suit == Card.Suits.SPADE:
					hearts -= 1
			if hearts < 0:
				table_manager.turn_cards(1)
			else:
				_end_round()
		_: _end_round()
	phase += 1
	_next_turn()
	
func _end_round() -> void:
	for player in players:
		var score: int = table_manager.evaluate_score(player.hand)

func _next_turn() -> void:
	player_turn = (player_turn + 1) % players.size()
	var current_player = players[player_turn]
	if current_player == player_raised:
		_next_phase()
		
	current_player.play_turn()

# Signals
func _on_end_turn():
	_next_turn()

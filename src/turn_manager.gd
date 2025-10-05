extends Node3D

@export var hand_size: int = 2

@onready var table_manager: TableManager = $TableManager
@onready var players = $Players.get_children()

var active_players = []

var player_turn: int = 0

var big_blind_player: int = 0
var big_blind_amount: int = 5

var player_raised: int = -1

var phase: int = 0

func _ready() -> void:
	table_manager.player_folded.connect(_on_player_folded)
	table_manager.player_raised.connect(_on_player_raised)
	active_players = players.duplicate()
	for player in active_players:
		table_manager.add_player(player.id)
		player.end_turn.connect(_on_end_turn)
	SoundManager.get_intro_player().finished.connect(_on_intro_monologue_finished)
	
	_new_round()

func _process(_delta: float) -> void:
	for enemy in players:
		if enemy is Enemy:
			(enemy as Enemy).is_active = player_turn == enemy.id

func _on_intro_monologue_finished() -> void:
	pass# _new_round()

func _new_round() -> void:
	_evaluate_players()
	active_players = []
	active_players = players.duplicate()
	table_manager.deck = Deck.new()
	await _distribute_cards()
	big_blind_player = (big_blind_player + 1)
	if big_blind_player >= active_players.size():
		big_blind_player = big_blind_player % active_players.size()
	player_raised = big_blind_player
	_next_turn()
	
func _evaluate_players():
	var players_to_remove = []
	for player in active_players:
		# Play lose sounds for players
		# Lose screen if player being removed is player
		var money = table_manager.player_chips[player.id]
		if money <= 0:
			players_to_remove.append(player)
	for player in players_to_remove:
		players.remove_at(players.find(player))
		if player.id <= big_blind_player:
			big_blind_player -= 1

func _distribute_cards():
	for player in active_players:
		await get_tree().create_timer(1).timeout
		player.draw_cards(hand_size)
		
func _next_phase():
	match phase:
		0: pass # Distribute cards
		1: table_manager.turn_cards(3)
		2: table_manager.turn_cards(1)
		3: 
			table_manager.turn_cards(1)
		4:
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
	
func _end_round() -> void:
	var highest_scorer = active_players[0]
	var highest_score = 0
	for player in active_players:
		var score: int = table_manager.evaluate_score(player.hand)
		if score > highest_score:
			highest_scorer = player
			highest_score = score
	table_manager.move_winnings(highest_scorer.id)
	highest_scorer.win_hand()
	initialize_round()

func initialize_round():
	player_raised = -1
	phase = 0
	active_players = players.duplicate()
	for player in active_players:
		player.hide_hand()
	table_manager.reset_table()
	_new_round()

func _next_turn() -> void:
	await get_tree().create_timer(1).timeout
	player_turn = (player_turn + 1) % active_players.size()
	var current_player = active_players[player_turn]
	if current_player.id == player_raised:
		_next_phase()
		
	current_player.play_turn()

# Signals
func _on_end_turn():
	_next_turn()

func _on_player_folded(id: int):
	var player = active_players.filter(func (p): return p.id == id)
	player[0].hide_hand()
	active_players.remove_at(active_players.find(player[0]))

func _on_player_raised(id: int):
	player_raised = id

extends Node3D
class_name Player

@export var id: int
@export var table_manager: TableManager
@export var player_visuals: PlayerVisual

@onready var bet: HSlider = $UI/Control/VBoxContainer/Bet
@onready var money: Label = $UI/Control/Money
@onready var current_bet: Label = $UI/Control/VBoxContainer/CurrentBet
@onready var buttons: HBoxContainer = $UI/Control/VBoxContainer/Buttons

var _current_bet: int = 0

var hand: Array[Card] = []

signal end_turn

func _process(_delta: float) -> void:
	bet.max_value = table_manager.player_chips[id]
	money.text = str(table_manager.player_chips[id]) + "€"

func play_turn():
	for button in buttons.get_children():
		button.disabled = false

func _end_turn():
	for button in buttons.get_children():
		button.disabled = true
	end_turn.emit()

# Called from outside
func draw_cards(amount: int):
	for i in range(amount):
		hand.push_back(table_manager.deck.draw())
	player_visuals.display_cards(hand.duplicate())

func hide_hand():
	player_visuals.hide_cards()

# Signals
func _on_call_pressed() -> void:
	table_manager.call_bet(id)
	_end_turn()


func _on_check_pressed() -> void:
	table_manager.check(id)
	_end_turn()


func _on_raise_pressed() -> void:
	table_manager.raise(id, _current_bet)
	_end_turn()


func _on_fold_pressed() -> void:
	table_manager.fold(id)
	_end_turn()


func _on_bet_value_changed(value: float) -> void:
	_current_bet = int(value)
	current_bet.text = str(_current_bet) + "€"

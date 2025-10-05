extends Node3D
class_name Player

@export var id: int
@export var table_manager: TableManager
@export var player_visuals: PlayerVisual

@onready var bet: HSlider = $UI/Control/VBoxContainer/Bet
@onready var money: Label = $UI/Control/Money
@onready var current_bet: Label = $UI/Control/VBoxContainer/CurrentBet
@onready var buttons: HBoxContainer = $UI/Control/VBoxContainer/Buttons
@onready var voice_player: AudioStreamPlayer = $VoicePlayer
@onready var skip_intro_button: Button = $UI/Control/SkipIntroButton

const SADAN = preload("uid://bs1ulvn3oldnb")
const SA_FOR_FANDEN = preload("uid://b7iu2awcx153s")
const RILANCIO = preload("uid://sqnxwaxffmu1")
const BUSSO = preload("uid://nrlkit311aq0")
const CHIAMO = preload("uid://b0mdi3h4xx03f")
const PASSO = preload("uid://dmqcn7dexlnv0")

func play_voice_line(line) -> void:
	voice_player.stream = line
	voice_player.play()

var _current_bet: int = 5

var hand: Array[Card] = []

signal end_turn

func _process(_delta: float) -> void:
	bet.max_value = table_manager.player_chips[id]
	money.text = str(table_manager.player_chips[id]) + "€"

func play_turn():
	for button in buttons.get_children():
		button.disabled = false
	if table_manager.player_chips[id] > 0 and table_manager.current_bet > table_manager.table_chips[id]:
		buttons.get_child(1).disabled = true

func _end_turn():
	for button in buttons.get_children():
		button.disabled = true
	await get_tree().create_timer(2).timeout
	end_turn.emit()

# Called from outside
func draw_cards(amount: int):
	hand = []
	for i in range(amount):
		hand.push_back(table_manager.deck.draw())
	player_visuals.display_cards(hand.duplicate())

func hide_hand():
	player_visuals.hide_cards()

func win_hand():
	play_voice_line(SADAN)

# Signals
func _on_call_pressed() -> void:
	table_manager.call_bet(id)
	_end_turn()
	play_voice_line(CHIAMO)

func _on_check_pressed() -> void:
	table_manager.check(id)
	_end_turn()
	play_voice_line(BUSSO)

func _on_raise_pressed() -> void:
	table_manager.call_bet(id)
	table_manager.raise(id, _current_bet)
	_end_turn()
	play_voice_line(RILANCIO)

func _on_fold_pressed() -> void:
	table_manager.fold(id)
	_end_turn()
	play_voice_line(PASSO)


func _on_bet_value_changed(value: float) -> void:
	_current_bet = int(value)
	current_bet.text = str(_current_bet) + "€"

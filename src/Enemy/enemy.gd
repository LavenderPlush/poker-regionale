extends Node3D
class_name Enemy

@export var enemy_visual: EnemyVisual
@export var table_manager: TableManager

const NPC_1_CALL = preload("uid://d4juc1fekrswx")
const NPC_1_CHECK = preload("uid://c86shuy5wmtg6")
const NPC_1_FOLD = preload("uid://bqm5bfkx3daq8")
const NPC_1_GOD_DAMN = preload("uid://cm8afofxa3x5d")
const NPC_1_RAISE = preload("uid://dut8vp3tifvvt")
const NPC_1_WIN = preload("uid://cmipqfi2umtsr")

signal end_turn

var hand: Array[Card]
@export var id: int

var behaviour: Callable = random_raise

func play_turn():
	behaviour.call()
	
	await get_tree().create_timer(2).timeout
	end_turn.emit()

func check() -> void:
	table_manager.check(id)
	enemy_visual.audio_stream_player_3d.stream = NPC_1_CHECK
	enemy_visual.audio_stream_player_3d.play()

func fold():
	enemy_visual.hide_cards()
	table_manager.fold(id)

func call_bet():
	table_manager.call_bet(id)

func raise(amount: int):
	table_manager.raise(id, amount)

# Used from outside
func draw_cards(amount: int):
	for i in range(amount):
		hand.append(table_manager.deck.draw())
	enemy_visual.show_cardbacks()

func hide_hand():
	enemy_visual.hide_cards()

func win_hand():
	enemy_visual.audio_stream_player_3d.stream = NPC_1_WIN
	enemy_visual.audio_stream_player_3d.play()
	await enemy_visual.audio_stream_player_3d.finished

# AIs

func always_check():
	if table_manager.table_chips[id] == table_manager.current_bet:
		check()
	else:
		call_bet()

func random_raise():
	var max_bet = 20
	var raise_chance = 0.3
	
	var difference = table_manager.current_bet - table_manager.table_chips[id]
	var raise_val = randi() % (max_bet + 1)
	
	if raise_val + difference > table_manager.player_chips[id]:
		fold()
	elif randf() < raise_chance:
		table_manager.check(id) # TODO this should not be handled here
		raise(raise_val)
	else:
		call_bet()

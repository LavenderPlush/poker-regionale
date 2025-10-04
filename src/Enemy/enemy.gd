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

func play_turn():
	check()
	await get_tree().create_timer(2).timeout
	end_turn.emit()

func check() -> void:
	table_manager.check(id)
	enemy_visual.audio_stream_player_3d.stream = NPC_1_CHECK
	enemy_visual.audio_stream_player_3d.play()

func fold():
	enemy_visual.hide_cards()
	table_manager.fold(id)

func draw_cards(amount: int):
	for i in range(amount):
		hand.append(table_manager.deck.draw())
	enemy_visual.show_cardbacks()

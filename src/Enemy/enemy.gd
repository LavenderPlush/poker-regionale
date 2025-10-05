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

const NPC_2_CALL = preload("uid://di1uymvoieprj")
const NPC_2_CHECK = preload("uid://buwwct8hc1l7y")
const NPC_2_FOLD = preload("uid://co1ojxjjrnbw3")
const NPC_2_GOD_DAMN = preload("uid://0bnor4p074n")
const NPC_2_RAISE = preload("uid://l1vp4apxqtfi")
const NPC_2_WIN = preload("uid://376r4ymavhke")

const NPC_3_CALL = preload("uid://oi8rld7g7ya5")
const NPC_3_CHECK = preload("uid://csiu7aaq4hacq")
const NPC_3_FOLD = preload("uid://dhmdql5bsngr7")
const NPC_3_GOD_DAMN = preload("uid://do56qmp7gp1i0")
const NPC_3_RAISE = preload("uid://bftpymsyvh4la")
const NPC_3_WIN = preload("uid://cyialc73mkqg8")

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

# Used from outside
func draw_cards(amount: int):
	for i in range(amount):
		hand.append(table_manager.deck.draw())
	enemy_visual.show_cardbacks()

func hide_hand():
	enemy_visual.hide_cards()

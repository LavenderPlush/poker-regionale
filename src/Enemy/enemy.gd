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

const NPC_5_CALL = preload("uid://7cx1r3nnxr8r")
const NPC_5_CHECK = preload("uid://brebskwj22x5f")
const NPC_5_FOLD = preload("uid://bjglpf4ue8pq2")
const NPC_5_GOD_DAMN = preload("uid://bga3nsonwbl0h")
const NPC_5_RAISE = preload("uid://bow3p85q371v6")
const NPC_5_WIN = preload("uid://dpbftvy5s6iym")

const call_lines = [
	NPC_5_CALL,
	NPC_1_CALL,
	NPC_2_CALL,
	NPC_3_CALL,
]

const check_lines = [
	NPC_5_CHECK,
	NPC_1_CHECK,
	NPC_2_CHECK,
	NPC_3_CHECK,
]

const fold_lines = [
	NPC_5_FOLD,
	NPC_1_FOLD,
	NPC_2_FOLD,
	NPC_3_FOLD,
]

const god_damn_lines = [
	NPC_5_GOD_DAMN,
	NPC_1_GOD_DAMN,
	NPC_2_GOD_DAMN,
	NPC_3_GOD_DAMN,
]

const raise_lines = [
	NPC_5_RAISE,
	NPC_1_RAISE,
	NPC_2_RAISE,
	NPC_3_RAISE,
]

const win_lines = [
	NPC_5_WIN,
	NPC_1_WIN,
	NPC_2_WIN,
	NPC_3_WIN,
]

signal end_turn

var hand: Array[Card]
var is_active: bool = false
@export var id: int

var behaviour: Callable = rainbow_gambler

func _process(_delta: float) -> void:
	enemy_visual.turn_indicator.visible = is_active

func play_turn():
	if hand:
		behaviour.call()
		await get_tree().create_timer(2).timeout

	end_turn.emit()

func check() -> void:
	table_manager.check(id)
	enemy_visual.play_voice_line(check_lines[id])

func fold():
	enemy_visual.hide_cards()
	table_manager.fold(id)
	enemy_visual.play_voice_line(fold_lines[id])

func call_bet():
	table_manager.call_bet(id)
	enemy_visual.play_voice_line(call_lines[id])

func raise(amount: int):
	table_manager.raise(id, amount)
	enemy_visual.play_voice_line(raise_lines[id])

# Used from outside
func draw_cards(amount: int):
	for i in range(amount):
		hand.append(table_manager.deck.draw())
	enemy_visual.show_cardbacks()

func hide_hand():
	enemy_visual.hide_cards()

func win_hand():
	enemy_visual.play_voice_line(win_lines[id])

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
	
	if difference > table_manager.player_chips[id]:
		fold()
	elif randf() < raise_chance and difference + raise_val:
		table_manager.check(id) # TODO this should not be handled here
		raise(raise_val)
	else:
		call_bet()

func rainbow_gambler():
	var raise_val = 40
	if hand[0].suit == hand[1].suit:
		fold()
	else:
		var difference = table_manager.current_bet - table_manager.table_chips[id]
		if table_manager.current_bet < 40 and table_manager.player_chips[id] >= 40 + difference:
			table_manager.check(id)
			raise(raise_val)
		elif difference == 0:
			check()
		elif difference <= table_manager.player_chips[id]:
			call_bet()
		else:
			fold()

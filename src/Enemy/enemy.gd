extends Node3D

@export var enemy_visual: EnemyVisual
@export var table_manager: TableManager

signal end_turn

var hand: Array[Card]
@export var id: int

func play_turn():
	table_manager.check(id)
	await get_tree().create_timer(2).timeout
	end_turn.emit()

func fold():
	enemy_visual.hide_cards()
	table_manager.fold(id)

func draw_cards(amount: int):
	for i in range(amount):
		hand.append(table_manager.deck.draw())
	enemy_visual.show_cardbacks()

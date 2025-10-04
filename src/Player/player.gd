extends Node3D
class_name Player

@export var id: int
@export var table_manager: TableManager
@export var player_visuals: PlayerVisual

var hand: Array[Card] = []

signal end_turn

func play_turn():
	end_turn.emit()
	pass
	
func draw_cards(amount: int):
	for i in range(amount):
		hand.push_back(table_manager.deck.draw())
	player_visuals.display_cards(hand)
	

extends Node3D
class_name TableVisual

const CARD: PackedScene = preload("res://CardsDisplayed/card.tscn")

@onready var position_holder: Node3D = $CardPositions
var cards: Array[CardVisual] = []

var current_card: int = 0

func _ready() -> void:
	for c in position_holder.get_children():
		cards.append(c)

func show_card(card_data: Card):
	assert(current_card < cards.size())
	cards[current_card].display(card_data.rank, card_data.suit)
	cards[current_card].visible = true
	current_card += 1

# Called from outside
func reset_cards():
	for card in cards:
		card.visible = false
	current_card = 0

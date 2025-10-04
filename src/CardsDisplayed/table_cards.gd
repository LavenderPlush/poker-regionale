extends Node3D

const CARD: PackedScene = preload("res://CardsDisplayed/card.tscn")

@onready var position_holder: Node3D = $CardPositions
var positions: Array[Vector3] = []

var current_card: int = 0
var cards_played: Array[CardVisual] = []

func _ready() -> void:
	for pos in position_holder.get_children():
		positions.append(pos.position)

func show_card():
	assert(current_card < positions.size())
	var card: CardVisual = CARD.instantiate()
	# Use card given instead
	card.display(1, 1)
	cards_played.append(card)
	add_child(card)
	card.position = positions[current_card]
	current_card += 1
	
func reset_cards():
	for card in cards_played:
		card.queue_free()

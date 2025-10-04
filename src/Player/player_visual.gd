extends Camera3D

const CARD: PackedScene = preload("uid://dq5coxtle62he")

@onready var position_holder: Node = $PositionHolder

var positions: Array[Node3D] = []
var hand: Array = []

func _ready() -> void:
	for c in position_holder.get_children():
		positions.append(c)

func draw_cards(cards: Array[Card]):
	clear_hand()
	for c in range(positions.size()):
		var card: CardVisual = CARD.instantiate()
		card.display(cards[c].suit, cards[c].rank)
		hand.append(card)
		add_child(card)
		card.position = positions[c].position
		card.rotation = positions[c].rotation
	
func clear_hand():
	for c in hand:
		c.queue_free()
	hand = []

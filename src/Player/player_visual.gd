extends Camera3D

const CARD: PackedScene = preload("uid://dq5coxtle62he")

@onready var position_holder: Node = $PositionHolder

var positions: Array[Node3D] = []
var hand: Array = []

func _ready() -> void:
	for c in position_holder.get_children():
		positions.append(c)
	draw_cards([])

func draw_cards(_cards: Array = []):
	clear_hand()
	for c in range(positions.size()):
		var card: CardVisual = CARD.instantiate()
		# Fit this to card definition
		card.display(c, c)
		hand.append(card)
		add_child(card)
		card.position = positions[c].position
		card.rotation = positions[c].rotation
	
func clear_hand():
	for c in hand:
		c.queue_free()
	hand = []

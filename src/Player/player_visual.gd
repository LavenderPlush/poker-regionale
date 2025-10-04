extends Camera3D
class_name PlayerVisual

const CARD: PackedScene = preload("uid://dq5coxtle62he")

@onready var card_holder: Node3D = $CardHolder

var hand: Array = []

func _ready() -> void:
	for c in card_holder.get_children():
		hand.append(c)

func hide_cards():
	card_holder.visible = false

func show_cards():
	card_holder.visible = true
	
func display_cards(cards: Array[Card]):
	for i in range(hand.size()):
		hand[i].display(cards[i])
	
func clear_hand():
	for c in hand:
		c.queue_free()
	hand = []

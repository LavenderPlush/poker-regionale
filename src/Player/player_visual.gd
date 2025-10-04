extends Camera3D
class_name PlayerVisual

const CARD: PackedScene = preload("uid://dq5coxtle62he")

@onready var card_holder: Node3D = $CardHolder
@onready var rotation_goal = rotation

var hand: Array = []
const FIXED_X_DEG: float = deg_to_rad(-18.0)

func _ready() -> void:
	for c in card_holder.get_children():
		hand.append(c)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var screen_center = get_viewport().get_visible_rect().size / 2
		var diff = screen_center - event.position
		rotation_goal.y = diff.x / 10000
		rotation_goal.x = diff.y / 10000 + FIXED_X_DEG

func _physics_process(delta: float) -> void:
	rotation = rotation.move_toward(rotation_goal, delta * (rotation - rotation_goal).length() * 10)

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

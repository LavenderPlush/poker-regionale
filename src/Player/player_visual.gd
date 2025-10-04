extends Camera3D

const CARD: PackedScene = preload("uid://dq5coxtle62he")

@onready var position_holder: Node = $PositionHolder

var positions: Array[Node3D] = []
var hand: Array = []
const FIXED_X_DEG: float = deg_to_rad(-18.0)

func _ready() -> void:
	for c in position_holder.get_children():
		positions.append(c)
	print(rotation)

@onready var rotation_goal = rotation

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var screen_center = get_viewport().get_visible_rect().size / 2
		var diff = screen_center - event.position
		rotation_goal.y = diff.x / 10000
		rotation_goal.x = diff.y / 10000 + FIXED_X_DEG

func _physics_process(delta: float) -> void:
	rotation = rotation.move_toward(rotation_goal, delta * (rotation - rotation_goal).length() * 10)

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

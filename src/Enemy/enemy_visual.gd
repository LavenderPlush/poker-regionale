extends Node3D
class_name EnemyVisual

@onready var card_holder: Node3D = $CardHolder
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var turn_indicator: AnimatedSprite3D = $TurnIndicator

@onready var talking_animation: AnimationPlayer = $TalkingAnimation

var hand: Array

@export var flip_sprite: bool = false

func _ready() -> void:
	hand = card_holder.get_children()
	show_cardbacks()
	hide_cards()

func play_voice_line(stream) -> void:
	audio_stream_player_3d.stream = stream
	audio_stream_player_3d.play()

func hide_cards():
	card_holder.visible = false

func show_cards():
	card_holder.visible = true

func display_cards(cards: Array[Card]):
	hide_cards()
	for i in range(hand.size()):
		hand[i].display(cards[i])
	show_cards()

func show_cardbacks():
	show_cards()
	for card in hand:
		card.display(1,4)

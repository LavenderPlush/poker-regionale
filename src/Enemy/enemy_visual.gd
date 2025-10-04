extends Sprite3D
class_name EnemyVisual

const npc1_front_sprite: Texture2D = preload("res://Assets/NPC1_Front.png")
const npc2_side_sprite: Texture2D = preload("res://Assets/NPC2_Side.png")
const npc4_side_sprite: Texture2D = preload("res://Assets/NPC4_Side.png")

@onready var card_holder: Node3D = $CardHolder
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

var hand: Array

const npc_textures = [
	npc1_front_sprite,
	npc2_side_sprite,
	npc4_side_sprite,
]

enum NPC {
	NPC1_front,
	NPC2_side,
	NPC4_side,
}

@export var flip_sprite: bool = false
@export var npc_texture: NPC = NPC.NPC1_front

func _ready() -> void:
	texture = npc_textures[npc_texture]
	hand = card_holder.get_children()
	show_cardbacks()

func hide_cards():
	card_holder.visible = false

func show_cards():
	card_holder.visible = true

func display_cards(cards: Array[Card]):
	for i in range(hand.size()):
		hand[i].display(cards[i])

func show_cardbacks():
	show_cards()
	for card in hand:
		card.display(1,4)

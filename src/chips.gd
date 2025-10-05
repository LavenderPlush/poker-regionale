extends Node3D
class_name Chips

@export var table_manager: TableManager
@export var enemy: Enemy
@onready var blue_chips: Sprite3D = $BlueChips
@onready var red_chips: Sprite3D = $RedChips
@onready var green_chips: Sprite3D = $GreenChips
@onready var label_3d: Label3D = $Label3D

const MAX_THRESHOLD: int = 80
const MID_THRESHOLD: int = 40
const MIN_THRESHOLD: int = 1

func _process(_delta: float) -> void:
	var player_chips = table_manager.player_chips[enemy.id]
	blue_chips.visible = player_chips >= MAX_THRESHOLD
	red_chips.visible = player_chips >= MID_THRESHOLD
	green_chips.visible = player_chips >= MIN_THRESHOLD
	label_3d.text = str(player_chips) + "€"

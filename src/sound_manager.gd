extends Node

@onready var intro_player: AudioStreamPlayer = $IntroPlayer

func _ready() -> void:
	$BGMPlayer.play()
	AudioServer.set_bus_volume_db(1, -12)
	
	$IntroPlayer.play()

func get_intro_player() -> AudioStreamPlayer:
	return intro_player

func _on_intro_player_finished() -> void:
	AudioServer.set_bus_volume_db(1,0)

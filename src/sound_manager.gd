extends Node3D

func _ready() -> void:
	$BGMPlayer.play()
	AudioServer.set_bus_volume_db(1, -12)
	
	$VoicePlayer.play()


func _on_voice_player_finished() -> void:
	AudioServer.set_bus_volume_db(1,0)

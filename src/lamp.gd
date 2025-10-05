extends SpotLight3D

@onready var flicker_timer: Timer = $FlickerTimer

const NORMAL_ENERGY: float = 5.0

func _on_flicker_timer_timeout() -> void:
	light_energy = 2.0
	await get_tree().create_timer(0.4).timeout
	light_energy = 5.0
	await get_tree().create_timer(0.1).timeout
	light_energy = 2.0
	await get_tree().create_timer(0.07).timeout
	light_energy = 5.0

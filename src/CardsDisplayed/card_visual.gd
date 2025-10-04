extends Sprite3D
class_name CardVisual

func display(x: int, y: int):
	set_frame_coords(Vector2i(x - 1, y))

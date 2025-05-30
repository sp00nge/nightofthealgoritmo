extends Area2D

var directions = []
# 0, 180, 360 = horizontal
# 90, 270 = vertical

func set_directions(rot):
	if rot == 0 or rot == 360 or rot == 180:
		directions = [Vector2.RIGHT, Vector2.LEFT]
	elif rot == 90 or rot == 270:
		directions = [Vector2.DOWN, Vector2.UP]
	return directions

func send_directions(input):
	if (input * -1) == directions[0]:
		return directions[1]
	elif (input * -1) == directions[1]:
		return directions[0]
	else:
		return input * -1

func init(_rotation ,_position: Vector2):
	rotation_degrees = _rotation
	set_directions(rotation_degrees)
	position = _position
	scale = Vector2(4.167, 4.167)

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed('click'):
		if rotation_degrees == 360:
			rotation_degrees = 0
		rotation_degrees += 90
		set_directions(rotation_degrees)

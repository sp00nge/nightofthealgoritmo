extends Area2D

signal reached_goal
signal fell

var animation_speed = 3
var moving = false
var tile_size = 32*4.167
var next_pos = Vector2.ZERO
var current_dir = Vector2.ZERO
var queued_direction = Vector2.ZERO

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

func reset(_position: Vector2):
	position = _position

func move(dir):
	current_dir = dir
	next_pos = Vector2(position) + dir * tile_size
	await do_move(dir)

func do_move(dir):
	$AnimationPlayer.play("walk")
	var tween = create_tween()
	tween.tween_property(self ,"position", next_pos, 1.0 / animation_speed).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false
	$AnimationPlayer.play("idle")
	if queued_direction != Vector2.ZERO:
		var next = queued_direction
		queued_direction = Vector2.ZERO
		await move(next)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("edges"):
		fell.emit()
	elif area.is_in_group("bridge"):
		var next_dir = area.send_directions(current_dir)
		queued_direction = next_dir
	elif area.is_in_group("exit"):
		emit_signal("reached_goal")

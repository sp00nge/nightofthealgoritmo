extends Area2D

signal reached_exit

@onready var ray = $RayCast2D
var animation_speed = 3
var moving = false
var tile_size = 32 #cambiar
var next_pos = Vector2.ZERO
var current_dir = Vector2.ZERO

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

func reset(_position: Vector2):
	position = _position

func _unhandled_input(event: InputEvent) -> void:
	if moving == false:
		if event.is_action_pressed("down"):
			move(inputs["down"])
		elif event.is_action_pressed("up") :
			move(inputs["up"])
		elif event.is_action_pressed("left"):
			move(inputs["left"])
		elif event.is_action_pressed("right"):
			move(inputs["right"])


func move(dir):
	next_pos = Vector2(position) + dir * tile_size
	ray.target_position = dir * tile_size
	ray.force_raycast_update()
	if next_pos.x < 0 or next_pos.x > 800:
		return
	elif next_pos.y < 128 or next_pos.y > 800:
		return
	else:
		if ray.is_colliding():
			return
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


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("exit"):
		emit_signal("reached_exit")

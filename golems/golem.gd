extends Area2D

signal clicked(golem)
signal order_added(dir, index)
signal reached_goal

@onready var ray = $RayCast2D

enum {SELECTED, IDLE}

var animation_speed = 3
var moving = false
var tile_size = 56
var next_pos = Vector2.ZERO
var previous_pos = Vector2.ZERO
var has_key = false
var state = null
var move_order = []

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

func get_move_order():
	return move_order.size()

func change_state(new_state):
	if new_state == "SELECTED":
		state = SELECTED
	elif new_state == "IDLE":
		state = IDLE
	#state = new_state
	match state:
		IDLE:
			$Sprite2D.material.set_shader_parameter("width", 0)
			$AnimationPlayer.play("walk_left")
		SELECTED:
			$AnimationPlayer.play("disappear")
			$AnimationPlayer.queue("walk_left")

func _ready():
	$AnimationPlayer.play("walk_left")
	position = position.snapped(Vector2.ONE * tile_size)

#func _process(delta: float) -> void:
	#print(move_order)
func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		emit_signal("clicked", self)

func _unhandled_input(event: InputEvent) -> void:
	if state == SELECTED and moving == false:
		if event.is_action_pressed("down") and move_order.size() < 9:
			move_order.append(inputs["down"])
			order_added.emit(inputs["down"], move_order.size()-1)
		
		elif event.is_action_pressed("up") and move_order.size() < 9:
			move_order.append(inputs["up"])
			order_added.emit(inputs["up"], move_order.size()-1)
		
		elif event.is_action_pressed("left") and move_order.size() < 9:
			move_order.append(inputs["left"])
			order_added.emit(inputs["left"], move_order.size()-1)
		
		elif event.is_action_pressed("right") and move_order.size() < 9:
			move_order.append(inputs["right"])
			order_added.emit(inputs["right"], move_order.size()-1)

func move():
	for dir in move_order:
		print(dir)
		next_pos = Vector2(position) + dir * tile_size
		ray.target_position = dir * tile_size
		ray.force_raycast_update()
		if next_pos.x < 0 or next_pos.x > 672:
			return
		elif next_pos.y < 0 or next_pos.y > 800:
			return
		else:
			if !ray.is_colliding():
				await do_move(dir)
			elif ray.is_colliding():
				var collision = ray.get_collider()
				if collision is Node:
					if collision.is_in_group("doors"):
						if has_key:
							await do_move(dir)
					elif collision.is_in_group("pushable"):
						if collision.has_method("can_move") and collision.has_method("move"):
							var direction = Vector2(sign(ray.target_position.x), sign(ray.target_position.y))
							if collision.can_move(direction):
								await collision.move(direction)
								await do_move(dir)

func do_move(dir):
	$AnimationPlayer.play("walk_%s" % dir)
	previous_pos = position
	var tween = create_tween()
	tween.tween_property(self ,"position", next_pos, 1.0 / animation_speed).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false
	

func reset(_position: Vector2):
	position = _position

func disappear():
	$AnimationPlayer.play("disappear")

func set_key():
	has_key = true
	
func can_open():
	if has_key:
		return true

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("doors"):
		if can_open():
			area.queue_free()
	elif area.is_in_group("keys"):
		if has_key:
			return
		else:
			set_key()
			area.queue_free()
	elif area.is_in_group("ghosts"):
			emit_signal("reached_goal")
	else:
		return

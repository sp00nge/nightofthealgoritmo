extends Area2D

@onready var ray = $RayCast2D
var tile_size = 56
var next_pos = Vector2.ZERO
var animation_speed = 3
var moving = false

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var textures = {
	"barrel": "res://assets/usables/barrel.png",
	"logs": "res://assets/usables/logs.png",
	"pot_closed": "res://assets/usables/pot_closed.png",
	"pot_open": "res://assets/usables/pot_open.png",
	"rock": "res://assets/usables/rock.png"
}

func init(texture ,_position: Vector2):
	$Sprite2D.texture = load(textures[texture])
	position = _position

func can_move(dir):
	next_pos = position + dir * tile_size
	ray.target_position = dir * tile_size
	ray.force_raycast_update()
	if next_pos.x < 0 or next_pos.x > 672:
		return
	elif next_pos.y < 0 or next_pos.y > 800:
		return
	else:
		if ray.is_colliding():
			return false
		return true
	
func move(dir):
	next_pos = position + dir * tile_size
	ray.target_position = dir * tile_size
	ray.force_raycast_update()
	if next_pos.x < 0 or next_pos.x > 672:
		return
	elif next_pos.y < 0 or next_pos.y > 800:
		return
	else:
		if !ray.is_colliding():
			var tween = create_tween()
			tween.tween_property(self ,"position", next_pos, 1.0 / animation_speed).set_trans(Tween.TRANS_SINE)
			moving = true
			await tween.finished
			moving = false
			#position = next_pos

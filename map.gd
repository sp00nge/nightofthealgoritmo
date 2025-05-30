extends CanvasLayer

var world_num = GameState.current_world

func _ready() -> void:
	set_sprite()
	await get_tree().create_timer(5).timeout
	continue_to_game()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		continue_to_game()

func continue_to_game():
	get_tree().change_scene_to_file(GameState.game_scene)


func set_sprite():
	var marker_name = "World" + str(world_num)
	var marker = $Worlds.get_node(marker_name)
	if marker:
		$AnimatedSprite2D.global_position = marker.global_position
	else:
		print("Marker not found")

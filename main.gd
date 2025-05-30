extends Node

func get_world(world):
	if world == 1:
		return "golems"
	elif world == 2:
		return "bridge"
	elif world == 3:
		return "sliding"
	elif world == 4:
		return "maze"
	elif world == 5:
		return "garlic"

func _ready():
	var world_num = get_world(GameState.current_world)
	var level_num = str(GameState.current_level)
	var path = "res://%s/levels/%s_level_%s.tscn" % [world_num, world_num, level_num]
	var level = load(path).instantiate()
	add_child(level)

func _unhandled_input(event: InputEvent) -> void:
		if event.is_action_pressed("reset"):
			get_tree().reload_current_scene()

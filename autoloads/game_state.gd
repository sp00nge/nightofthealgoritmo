extends Node

var num_worlds = 1
var num_levels = 1
var current_level = 0
var current_world = 1
var game_scene = "res://main.tscn"
var title_screen = "res://ui/title_screen.tscn"
var map_scene = "res://map.tscn"

func restart():
	current_level = 0
	current_world = 1
	get_tree().change_scene_to_file(title_screen)
	
func next_level():
	current_level += 1
	
	if current_level == 1 and current_world == 1:
		get_tree().change_scene_to_file(map_scene)
		return
		
	if current_level > num_levels:
		current_world += 1
		current_level = 1
		get_tree().change_scene_to_file(map_scene)
		return
	get_tree().change_scene_to_file(game_scene)
		

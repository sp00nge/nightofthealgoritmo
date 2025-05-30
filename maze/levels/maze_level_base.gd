extends Node2D

@onready var ui = $GhostUI
@onready var hud = $HUD
@onready var complete_level = hud.get_node("PanelContainer2")

var complete = false
var is_moving = false

func _ready() -> void:
	$Spawn.hide()
	complete_level.hide()
	spawn_player()
	$PlayerMaze.reached_exit.connect(_on_player_reached_goal)

func _unhandled_input(event: InputEvent) -> void:
		#if !complete:
			#get_tree().reload_current_scene()
	if event.is_action_pressed("skip"):
		show_level_complete()

func spawn_player():
	var player_cell = $Spawn.get_used_cells()
	for cell in player_cell:
		var data = $Spawn.get_cell_tile_data(cell)
		var type = data.get_custom_data("type")
		var spawn_pos = $Spawn.map_to_local(cell) + Vector2(0, 128)

		if type == "spawn":
			$PlayerMaze.reset(spawn_pos)

func show_level_complete():
	complete_level.show()

func _on_player_reached_goal():
	show_level_complete()

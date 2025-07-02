extends Node2D

@onready var hud = $HUD
@onready var complete_level = hud.get_node("PanelContainer2")
@onready var complete_sound = complete_level.get_node("AudioStreamPlayer")
@onready var score_text = hud.get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Score")

var bridge_s_scene = load("res://bridge/bridge_tile.tscn")
var bridge_c_scene = load("res://bridge/bridge_tile_curve.tscn")
var is_moving = false
var complete = false

func _ready() -> void:
	$Spawns.hide()
	complete_level.hide()
	$TileMapLayer2.hide()
	spawn_bridge()
	spawn_player()
	$Player.fell.connect(_on_player_fell)
	$Player.reached_goal.connect(_on_player_reached_goal)
	#$Golem.reached_goal.connect(_on_golem_reached_goal)
	#$Golem2.reached_goal.connect(_on_golem_reached_goal)
	
func spawn_bridge():
	var bridge_cells = $TileMapLayer2.get_used_cells()
	for cell in bridge_cells:
		var data = $TileMapLayer2.get_cell_tile_data(cell)
		var type = data.get_custom_data("type")
		if type == 'bridge_s':
			var bridge_rotation = data.get_custom_data("rotation")
			var spawn_pos = $TileMapLayer2.map_to_local(cell) * 4.167 + Vector2(0,128)
			var bridge = bridge_s_scene.instantiate()
			add_child(bridge)
			bridge.init(bridge_rotation, spawn_pos)
		elif type == 'bridge_c':
			var bridge_rotation = data.get_custom_data("rotation")
			var spawn_pos = $TileMapLayer2.map_to_local(cell) * 4.167 + Vector2(0,128)
			var bridge = bridge_c_scene.instantiate()
			add_child(bridge)
			bridge.init(bridge_rotation, spawn_pos)

func spawn_player():
	var player_cell = $Spawns.get_used_cells()
	for cell in player_cell:
		var data = $Spawns.get_cell_tile_data(cell)
		var type = data.get_custom_data("spawn")
		var spawn_pos = $Spawns.map_to_local(cell) * 4.167  + Vector2(0,128)
		$Player.reset(spawn_pos)

func show_level_complete():
	complete_level.show()
	complete_sound.play()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("enter") and is_moving == false:
		is_moving = true
		await $Player.move(Vector2.RIGHT)
		is_moving = false
		if !complete:
			GameState.add_retry(GameState.current_world, GameState.current_level)
			get_tree().reload_current_scene()
	if event.is_action_pressed("skip"):
		show_level_complete()
		
func _on_player_fell():
	GameState.add_retry(GameState.current_world, GameState.current_level)
	get_tree().reload_current_scene()
	
func _on_player_reached_goal():
	var moves = $Player.get_moves()
	complete = true
	GameState.set_score(GameState.current_world, GameState.current_level, moves)
	score_text.text = str(moves)
	show_level_complete()

extends Node2D

@export var grid_size := 3
@export var set_level := 1
@export var base_image: Texture2D

@onready var hud = $HUD
@onready var score_text = hud.get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Score")
@onready var complete_level = hud.get_node("PanelContainer2")
@onready var complete_sound = complete_level.get_node("AudioStreamPlayer")


var grid = []
var correct_grid = []
var positions = []
var empty_pos = Vector2.ZERO
var offset_x = 80 
var offset_y = 144
var complete = false
var moving = false
var moves = 0
var start_time: int

# levels
var tile_layouts = {
	1: [
		[2, 7, 5],
		[4, 6, 1],
		[3, 0, null],
	],
	2: [
		[2, 5, 6],
		[7, 0, 3],
		[4, 1, null],
	],
	3: [
		[ 7,  4,  5,  10],
		[ 6,  13,  1,  12],
		[ 2, 11,  14, 3],
		[0, 9, 8, null],
	],
	4: [
		[ 12,  2,  10,  8],
		[ 14,  11,  13,  6],
		[ 7, 4,  0, 3],
		[9, 1, 5, null],
	]
}

func get_tile_size() -> float:
	return 640.0 / grid_size


func generate_positions(n):
	var positions := []
	var tile_size = get_tile_size()

	for y in range(n):
		var row := []
		for x in range(n):
			var pos = Vector2(offset_x + x * tile_size, offset_y + y * tile_size)
			row.append(pos)
		positions.append(row)
	return positions


func _ready():
	start_time = Time.get_unix_time_from_system()
	complete_level.hide()
	
	grid.resize(grid_size)
	
	for y in grid_size:
		grid[y] = []
		
	positions = generate_positions(grid_size)
	print(positions)

 #set correct grid
	var tile_index = 0
	for y in range(grid_size):
		for x in range(grid_size):
			if tile_index >= $Tiles.get_child_count():
				grid[y].append(null)
				continue
			
			var tile = $Tiles.get_child(tile_index)
			tile.scale = Vector2(0.625,0.625)
			tile.position = positions[y][x]
			grid[y].append(tile)
			tile_index += 1
	correct_grid = grid.duplicate()
	empty_pos = positions[-1][-1]

# set level grid
	grid = []
	grid.resize(grid_size)
	for y in grid_size:
		grid[y] = []
	
	var layout = tile_layouts[set_level]
	for y in range(grid_size):
		for x in range(grid_size):
			tile_index = layout[y][x]
			if tile_index == null:
				grid[y].append(null)
				empty_pos = positions[y][x]
				continue
			var tile = $Tiles.get_child(tile_index)
			tile.scale = Vector2(Vector2(0.625,0.625))
			tile.position = positions[y][x]
			grid[y].append(tile)
			
	print(grid)
	print(empty_pos)
	print(positions)

func _unhandled_input(event: InputEvent) -> void:
	if complete == false and moving == false:
		if event.is_action_pressed("up"):
			move_tile("up")
		elif event.is_action_pressed("down"):
			move_tile("down")
		elif event.is_action_pressed("left"):
			move_tile("left")
		elif event.is_action_pressed("right"):
			move_tile("right")
	if event.is_action_pressed("skip"):
		complete_level.show()

func find_position(matrix, value):
	for y in matrix.size():
		for x in matrix[y].size():
			if matrix[y][x] == value:
				return Vector2(x, y)
	return null

func move_tile(dir: String):
	print("SE REALIZA MOVIMIENTO HACIA %s", dir)
	var empty_index = find_position(positions, empty_pos)
	var from = empty_index
	var to = from
	
	match dir:
		"up": to.y += 1
		"down": to.y -= 1
		"left": to.x += 1
		"right": to.x -= 1
		_: return
	
	if to.x < 0 or to.y < 0 or to.x == grid_size or to.y == grid_size:
		return
		
	var tile = grid[to.y][to.x]
	var tween = get_tree().create_tween()
	if tile == null: return
	moving = true
	tween.tween_property(tile, "position", positions[from.y][from.x], 0.25)
	#tile.position = positions[from.y][from.x]
	grid[from.y][from.x] = tile
	grid[to.y][to.x] = null

	empty_pos = positions[to.y][to.x]
	
	print(positions)
	print(grid)
	print(empty_pos)
	print(positions.find(empty_pos, 0))
	
	moves += 1
	score_text.text = str(moves)
	moving = false
	check_win()

func check_win():
	for y in range(grid_size):
		for x in range(grid_size):
			var current_tile = grid[y][x]
			var correct_tile = correct_grid[y][x]

			if current_tile != correct_tile:
				return 
	complete = true
	complete_level.show()
	complete_sound.play()
	GameState.set_score(GameState.current_world, GameState.current_level, moves)
	var end_time = Time.get_unix_time_from_system()
	var duration = floori(end_time - start_time)
	GameState.set_time(GameState.current_world, GameState.current_level, duration)
	print(duration)

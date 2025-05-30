extends Node2D

@onready var ui = $GhostUI
@onready var hud = $HUD
@onready var p1_label = ui.get_node("PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Label")
@onready var p2_label = ui.get_node("PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2/Label2")
@onready var p1_orders = ui.get_node("PanelContainer/MarginContainer/HBoxContainer/VBoxContainer")
@onready var p2_orders = ui.get_node("PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2")
@onready var complete_level = hud.get_node("PanelContainer2")

var usable_scene = load("res://golems/pushable.tscn")
var door_scene = load("res://golems/door.tscn")
var key_scene = load("res://golems/key.tscn")

enum {SELECTED, IDLE}
enum {Golem, Golem2}

var is_moving = false
var selected_ghost = null
var ghosts_at_goal = []
var complete = false

func _ready() -> void:
	$Spawns.hide()
	$Usables.hide()
	$ItemsSpawn.hide()
	complete_level.hide()
	spawn_golems()
	spawn_usables()
	spawn_keys()
	$Golem.clicked.connect(_on_golem_clicked)
	$Golem2.clicked.connect(_on_golem_2_clicked)
	$Golem.order_added.connect(_on_golem_order_added)
	$Golem2.order_added.connect(_on_golem_2_order_added)
	$Golem.reached_goal.connect(_on_golem_reached_goal)
	$Golem2.reached_goal.connect(_on_golem_reached_goal)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("enter") and is_moving == false:
		is_moving = true
		await $Golem.move()
		await $Golem2.move()
		is_moving = false
		if !complete:
			get_tree().reload_current_scene()
	#if event.is_action_pressed("reset"):
		#get_tree().reload_current_scene()
	if event.is_action_pressed("skip"):
		show_level_complete()

func spawn_usables():
	var usable_cells = $Usables.get_used_cells()
	for cell in usable_cells:
		var data = $Usables.get_cell_tile_data(cell)
		var type = data.get_custom_data("type")
		if type == 'pushable':
			var name = data.get_custom_data("name")
			var spawn_pos = $Usables.map_to_local(cell) * 1.75 + Vector2(0,128)
			var usable = usable_scene.instantiate()
			add_child(usable)
			usable.init(name, spawn_pos)
		elif type == 'door':
			var spawn_pos = $Usables.map_to_local(cell) * 1.75 + Vector2(0,128)
			var usable = door_scene.instantiate()
			add_child(usable)
			usable.init(spawn_pos)

func spawn_keys():
	var key_cells = $ItemsSpawn.get_used_cells()
	for cell in key_cells:
		var data = $ItemsSpawn.get_cell_tile_data(cell)
		var type = data.get_custom_data("type")
		var spawn_pos = $ItemsSpawn.map_to_local(cell) * 1.75 + Vector2(0,128)
		var usable = key_scene.instantiate()
		add_child(usable)
		usable.init(spawn_pos)

func spawn_golems():
	var golem_cells = $Spawns.get_used_cells()
	for cell in golem_cells:
		var data = $Spawns.get_cell_tile_data(cell)
		var type = data.get_custom_data("spawn")
		var spawn_pos = $Spawns.map_to_local(cell) * 1.75  + Vector2(0,128)

		if type == 1:
			$Golem.reset(spawn_pos)
		elif type == 2:
			$Golem2.reset(spawn_pos)

func _on_golem_area_entered(area: Area2D) -> void:
	if area.is_in_group("ghosts"):
		await area.disappear()
		complete = true
		show_level_complete()

#func _process(delta: float) -> void:
	#print("Current ghost: ", selected_ghost)
	

func _on_golem_clicked(golem: Variant) -> void:
	if selected_ghost == Golem:
		return
	else:
		selected_ghost = Golem
		$Golem.change_state("SELECTED")
		$Golem2.change_state("IDLE")
		p1_label.label_settings.outline_color = Color.YELLOW
		p1_label.label_settings.outline_size = 1
		p2_label.label_settings.outline_color = Color.BLACK
		p2_label.label_settings.outline_size = 5
		print(selected_ghost)

func _on_golem_2_clicked(golem: Variant) -> void:
	if selected_ghost == Golem2:
		return
	else:
		selected_ghost = Golem2
		$Golem2.change_state("SELECTED")
		$Golem.change_state("IDLE")
		print(selected_ghost)
		p2_label.label_settings.outline_color = Color.YELLOW
		p2_label.label_settings.outline_size = 1
		p1_label.label_settings.outline_color = Color.BLACK
		p1_label.label_settings.outline_size = 5


func _on_golem_order_added(dir: Variant, index: Variant) -> void:
	var texture = get_texture_for_dir(dir)
	if index < p1_orders.get_child_count():
		p1_orders.get_child(index+1).texture = texture


func _on_golem_2_order_added(dir: Variant, index: Variant) -> void:
	var texture = get_texture_for_dir(dir)
	if index < p2_orders.get_child_count():
		p2_orders.get_child(index+1).texture = texture

func get_texture_for_dir(dir: Vector2) -> Texture2D:
	var atlas := AtlasTexture.new()
	
	if dir == Vector2.UP:
		atlas.atlas = preload("res://assets/teclas/ARROWUP.png")
	elif dir == Vector2.DOWN:
		atlas.atlas = preload("res://assets/teclas/ARROWDOWN.png")
	elif dir == Vector2.LEFT:
		atlas.atlas = preload("res://assets/teclas/ARROWLEFT.png")
	elif dir == Vector2.RIGHT:
		atlas.atlas = preload("res://assets/teclas/ARROWRIGHT.png")
	atlas.region = Rect2(Vector2(0,0), Vector2(17,16))
	return atlas
	
func _on_golem_reached_goal(golem: Node):
	if not ghosts_at_goal.has(golem):
		ghosts_at_goal.append(golem)

	if ghosts_at_goal.size() == 2:
		show_level_complete()

func show_level_complete():
	complete_level.show()

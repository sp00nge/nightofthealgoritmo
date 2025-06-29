extends Node2D

@export var disk_num: int
@onready var spike1 = $Spike1
@onready var GarlicCloveScene = preload("res://garlic/garlic_clove.tscn")

@onready var ui = $GhostUI
@onready var hud = $HUD
@onready var score_text = hud.get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Score")
@onready var complete_level = hud.get_node("PanelContainer2")
@onready var complete_sound = complete_level.get_node("AudioStreamPlayer")

var moves = 0
var sizes = [0.4, 0.35, 0.3, 0.15]
var spike_stacks = {
	"Spike1": [],
	"Spike2": [],
	"Spike3": []
}

func spawn_garlic(number: int):
	
	for i in range(number):
		var garlic = GarlicCloveScene.instantiate()
		
		var marker_name = "Slot" + str(i)
		var marker = spike1.get_node(marker_name)
		var garlic_size = sizes[i]
		
		garlic.spawn_garlic(marker.global_position, garlic_size)
		add_child(garlic)
		spike_stacks["Spike1"].append(garlic)
		garlic.current_spike = "Spike1"

func can_drag(disk) -> bool:
	if disk.current_spike == "":
		return false
	var stack = spike_stacks[disk.current_spike]
	return stack.size() > 0 and stack[-1] == disk
	
func handle_drop(disk, spike_name: String) -> bool:
	var target_spike = get_node(spike_name)
	var stack = spike_stacks[spike_name]
	
	if stack.size() > 0:
		var top_disk = stack[-1]
		if disk.disk_size >= top_disk.disk_size:
			print("Invalid Move")
			return false
	
	var marker_name = "Slot" + str(stack.size())
	var marker = target_spike.get_node(marker_name)
	disk.global_position = marker.global_position
	
	if disk.current_spike != "" and disk.current_spike != spike_name:
		spike_stacks[disk.current_spike].erase(disk)
		
	spike_stacks[spike_name].append(disk)
	disk.current_spike = spike_name
	moves += 1
	check_level_complete()
	return true

func check_level_complete():
	if spike_stacks["Spike3"].size() == disk_num:
		show_level_complete()
	
func show_level_complete():
	complete_level.show()
	complete_sound.play()
	GameState.set_score(GameState.current_world, GameState.current_level, moves)
	
func _ready() -> void:
	complete_level.hide()
	spawn_garlic(disk_num)

func _unhandled_input(event: InputEvent) -> void:
		if event.is_action_pressed("skip"):
			show_level_complete()

func _process(delta: float) -> void:
	score_text.text = str(moves)

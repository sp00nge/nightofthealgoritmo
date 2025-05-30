extends CanvasLayer

@onready var zone_texture = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/TextureRect
@onready var zone_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Label

var zone_img = {
	"1": preload("res://assets/level_icons/ghost.png"),
	"2": preload("res://assets/level_icons/bridge.png"),
	"3": preload("res://assets/level_icons/sliding.png"),
	"4": preload("res://assets/level_icons/maze.png"),
	"5": preload("res://assets/level_icons/garlic.png")
}

func _on_button_pressed() -> void:
	GameState.next_level()

func _ready():
	update_level()
	
func update_level():
	var game_level = GameState.current_level
	var game_zone = GameState.current_world
	
	zone_texture.texture = zone_img[str(game_zone)]
	zone_label.text = "%s - %s" % [game_zone, game_level]

extends CanvasLayer

@onready var zone_texture = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/TextureRect
@onready var zone_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Label
@onready var tutorial_panel = $TutorialPanel
@onready var hoja1 = $TutorialPanel/MarginContainer/HBoxContainer/Tutorial
@onready var hoja2 = $TutorialPanel/MarginContainer/HBoxContainer/Tutorial2


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
	tutorial_panel.hide()
	
func update_level():
	var game_level = GameState.current_level
	var game_zone = GameState.current_world
	
	zone_texture.texture = zone_img[str(game_zone)]
	zone_label.text = "%s - %s" % [game_zone, game_level]

func open_tutorial():
	if tutorial_panel.visible:
		tutorial_panel.hide()
		return

	var world_id = str(GameState.current_world)
	if GameState.tutorials.has(world_id):
		var pages = GameState.tutorials[world_id]
		hoja1.text = pages[0]
		hoja2.text = pages[1]
	else:
		hoja1.text = "Tu objetivo es juntar a los fantasmas \n Dales instrucciones e intenta conseguir que se sobrepongan"
		hoja2.text = "Para dar instrucciones puedes seleccionar con CLICK cada fantasma \n Luego usa las flechas del teclado \n Finalmente presiona ENTER para ejecutar las instrucciones \n Presiona R para reiniciar el nivel"

	tutorial_panel.show()



func _on_texture_button_pressed() -> void:
	open_tutorial()

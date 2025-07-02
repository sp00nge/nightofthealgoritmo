extends CanvasLayer

@onready var hoja = $FinalPanel/MarginContainer/HBoxContainer/Hoja
@onready var hoja2 = $FinalPanel/MarginContainer/HBoxContainer/Hoja2
@onready var toggle_button = $TextureButton
@onready var button_label = $TextureButton/Label

var general_info = true



func _ready() -> void:
	var total = GameState.get_total_score()
	
	hoja.text = get_intentos_text()
	hoja2.text = "Tu puntaje final es:\n\n %d puntos\n\nGracias por jugar.\n¡Nos vemos en una próxima aventura!" % total
	button_label.text = "Ver Puntaje por Niveles"

func get_intentos_text() -> String:
	var text = "¡Felicidades!\n\n Lograste entrar a la habitacion del vampiro y rescataste a la princesa.\nIntentos:\n"
	var niveles = [
		[1, 1], [1, 2], [1, 3], [1, 4],
		[2, 1], [2, 2], [2, 3], [2, 4],
	]
	for pair in niveles:
		text += " %d-%d: %d intentos\n" % [pair[0], pair[1], GameState.get_attempts(pair[0], pair[1])]
	return text
	
func get_puntajes_hoja1() -> String:
	var text = "Puntajes por nivel (Mundos 1 y 2):\n"
	var niveles = [
		[1, 1], [1, 2], [1, 3], [1, 4],
		[2, 1], [2, 2], [2, 3], [2, 4]
	]
	for pair in niveles:
		text += " %d-%d: %d pts\n" % [pair[0], pair[1], GameState.get_score(pair[0], pair[1])]
	return text

func get_puntajes_hoja2() -> String:
	var text = "Puntajes por nivel (Mundos 3 a 5):\n"
	var niveles = [
		[3, 1], [3, 2], [3, 3], [3, 4],
		[4, 1], [4, 2],
		[5, 1], [5, 2]
	]
	for pair in niveles:
		text += " %d-%d: %d pts\n" % [pair[0], pair[1], GameState.get_score(pair[0], pair[1])]
	return text

func _on_texture_button_pressed() -> void:
	var total = GameState.get_total_score()
	general_info = !general_info
	
	if general_info:
		hoja.text = get_intentos_text()
		hoja2.text = "Tu puntaje final es:\n\n %d puntos\n\nGracias por jugar.\n¡Nos vemos en una próxima aventura!" % total
		button_label.text = "Ver puntaje por niveles"
	else:
		hoja.text = get_puntajes_hoja1()
		hoja2.text = "%s\nTotal: %d puntos" % [get_puntajes_hoja2(), total]
		button_label.text = "Ver información general"

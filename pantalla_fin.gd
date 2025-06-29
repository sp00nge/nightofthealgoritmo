extends CanvasLayer

@onready var hoja = $FinalPanel/MarginContainer/HBoxContainer/Hoja
@onready var hoja2 = $FinalPanel/MarginContainer/HBoxContainer/Hoja2

var total = GameState.get_total_score()


func _ready() -> void:
	hoja.text = "¡Felicidades!\n\nCada prueba superada te acercó más a la meta."
	hoja2.text = "Tu puntaje final es:\n\n %d puntos\n\nGracias por jugar.\n¡Nos vemos en una próxima aventura!" % total

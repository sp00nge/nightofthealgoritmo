extends Node

var num_worlds = 1
var num_levels = 1
var current_level = 0
var current_world = 1
var game_scene = "res://main.tscn"
var title_screen = "res://ui/title_screen.tscn"
var map_scene = "res://map.tscn"
var final_scene = "res://pantalla_fin.tscn"

var levels_per_world = {
	1: 4,
	2: 4,
	3: 4,
	4: 2,
	5: 2
}


var scores = {}

var tutorials = {
	"1": ["Tu objetivo es juntar a los fantasmas \n Dales instrucciones e intenta conseguir que se sobrepongan", "Click para seleccionar fantasma \n Flechas para dar instrucciones \n ENTER para ejecutar \n R para reiniciar nivel \n Consigue la menor cantidad de instrucciones"],
	"2": ["Cruza el puente \n Gira las tablas hasta hacerte camino", "Click para rotar tablas \n Enter para ejecutar \n R para reiniciar \n consigue el camino mas corto"],
	"3": ["Resuelve el Puzzle", "Usa las flechas para mover hacia el lugar vacio \n Consigue la menor cantidad de movimientos"],
	"4": ["Escapa del laberinto", "Usa las flechas para moverte \n Encuentra el camino mas corto"],
	"5": ["Torre de Hanoi \n Los dientes de ajo estan de menor a mayor \n logra moverlos todos hasta la tercera estaca \n Un diente mas grande nunca puede colocarse sobre uno pequeño", "Haz click y arrastra los dientes de ajo \n Consigue la menor cantidad de movimientos"]
}

func restart():
	current_level = 0
	current_world = 1
	get_tree().change_scene_to_file(title_screen)
	
func next_level():
	current_level += 1

	# Mostrar mapa antes del primer nivel del primer mundo
	if current_world == 1 and current_level == 1:
		get_tree().change_scene_to_file(map_scene)
		return

	# Si terminó el último nivel del mundo actual
	if current_level > levels_per_world.get(current_world, 1):
		current_world += 1
		current_level = 1

		# Si no hay más mundos, ir a la pantalla final
		if not levels_per_world.has(current_world):
			get_tree().change_scene_to_file(final_scene)
			return

		# Mostrar mapa antes de comenzar el siguiente mundo
		get_tree().change_scene_to_file(map_scene)
		return

	# Cargar siguiente nivel normalmente
	get_tree().change_scene_to_file(game_scene)
	
func set_score(world: int, level: int, score: int):
	var key = "m%s_n%s" % [world, level]
	if not scores.has(key) or scores[key] < score:
		scores[key] = score
		print("Puntaje registrado en ", key, ":", score)
		
func get_score(world: int, level: int):
	var key = "m%s_n%s" % [world, level]
	return scores.get(key, 0)
	
func get_total_score() -> int:
	var total = 0
	for score in scores.values():
		total += score
	return total

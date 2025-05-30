extends Area2D

var current_hovered_spike: Area2D = null
var is_dragging = false
var original_position
var disk_size = 1
var current_spike: String
var prev_spike: String


func spawn_garlic(pos: Vector2, size: float):
	global_position = pos
	scale = Vector2(size,size)
	disk_size = size
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var level = get_parent()
		var can_drag = level.can_drag(self)
		if event.is_pressed() and can_drag:
			if $Sprite2D.get_rect().has_point(to_local(event.position)):
				is_dragging= true
				original_position = global_position
		else:
			if is_dragging:
				is_dragging = false
				#chekear spike
				if current_hovered_spike:
					try_drop_on_spike(current_hovered_spike)
				else:
					global_position = original_position

func try_drop_on_spike(spike_node):
	var level = get_parent()
	if level.has_method("handle_drop"):
		var accepted = level.handle_drop(self, spike_node.name)
		if not accepted:
			global_position = original_position
	else:
		print("handle_drop Method doesn't exist")

func _ready() -> void:
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
func _process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()

func _on_area_entered(area):
	if area.is_in_group("spike"):
		current_hovered_spike = area

func _on_area_exited(area):
	if area == current_hovered_spike:
		current_hovered_spike = area

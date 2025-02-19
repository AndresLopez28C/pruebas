extends Node2D
@onready var label_inter : Label = $TextoInt
var interaccion_actual :=[]
var puede_interactuar := true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Usar") and puede_interactuar:
		if interaccion_actual:
			puede_interactuar=false
			label_inter.hide()
			
			await  interaccion_actual[0].interact.call()
			puede_interactuar = true

func _process(delta: float) -> void:
	if interaccion_actual and puede_interactuar:
		interaccion_actual.sort_custom(_mas_cercano)
		if interaccion_actual[0].puede_interactuar:
			label_inter.text = interaccion_actual[0].nombre_interaccion
			label_inter.show()
	else:
		label_inter.hide()
func _on_rango_intera_area_entered(area: Area2D) -> void:
	interaccion_actual.push_back(area)

func _mas_cercano(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist
	
func _on_rango_intera_area_exited(area: Area2D) -> void:
	interaccion_actual.erase(area)

extends CanvasLayer
@onready var estamina: ProgressBar = %Estamina
@onready var animaciones_ui: AnimationPlayer = $AnimacionesUI
var Escaner: bool = false
signal cansancio
var desactivado : bool =false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Correr") and !desactivado:
		estamina.value -= 20* delta
	else:
		estamina.value += 10* delta
	if estamina.value ==0:
		cansancio.emit()
		desactivado = true
	if estamina.value ==100:
		desactivado = false
func _input(event):
	if event.is_action_pressed("Escaner") and Escaner == false:
		print(",muestra escanerrr")
		animaciones_ui.play("Mostrar_tracker")
		Escaner = true
	elif event.is_action_pressed("Escaner") and Escaner == true:
		animaciones_ui.play("Ocultar_tracker")
		Escaner = false

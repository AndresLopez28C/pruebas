extends CanvasLayer
@onready var estamina: ProgressBar = %Estamina
signal cansancio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Correr"):
		estamina.value -= 20* delta
	else:
		estamina.value += 10* delta
	if estamina.value ==0:
		cansancio.emit()
func _input(event):
	pass

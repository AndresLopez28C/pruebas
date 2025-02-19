extends Area2D
@onready var interactuar: Area2D = $Interactuar
var jugador : JugadorOB
signal esconderseSignal
var entrar = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactuar.interact = _al_usar


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _al_usar()->void:
	esconderseSignal.emit(entrar)
	entrar = !entrar

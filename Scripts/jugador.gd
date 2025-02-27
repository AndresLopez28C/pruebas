extends CharacterBody2D
class_name JugadorOB
var velocidad = 80
var control : bool = true
var cansado : bool = false

@onready var pisadas: AudioStreamPlayer = %Pisadas
@export var es_visible: bool = true 
@onready var colision: CollisionShape2D = %CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var agotado: Timer = $Agotado

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
func _ready() -> void:
	var armario = get_node("../Armario")
	var ui = get_node("../UI")
	get_node("../UI/Tracker").setup_player(self)
	armario.esconderseSignal.connect(esconderse)
	ui.cansancio.connect(_cansado)

func _process(delta):
	if !control:
		pass
	else:
		var direction = Input.get_vector("Izquierda","Derecha","Arriba","Abajo")
		velocity = direction*velocidad
		move_and_slide()
		if(velocity!=Vector2.ZERO):
				if !pisadas.playing:
					_reproducir_pisadas()
func _reproducir_pisadas() ->void:
	pisadas.pitch_scale = randf_range(.8,1.2)
	pisadas.play()

func _input(event):
	if event.is_action_pressed("Correr") and !cansado:
		velocidad = 200
	if event.is_action_released("Correr"):
		velocidad= 100
	if event.is_action_pressed("Escaner"):
		control = !control

func esconderse(A: bool):
	if A: ##Estamos entrando a escondernos
		control = false
		es_visible = false
		sprite.visible = false
		colision.set_deferred("disabled", true)
	else:
		control = true
		es_visible = true
		sprite.visible = true
		colision.set_deferred("disabled", false)
		
func salir_del_escondite():
	control = true
	es_visible = true
	sprite.visible = true
	colision.set_deferred("disabled", false)
	
func _cansado() ->void:
	cansado = true
	velocidad= 100
	print("Se canso")
	agotado.start()
	


func _on_agotado_timeout() -> void:
	cansado = false

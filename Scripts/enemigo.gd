extends CharacterBody2D
class_name enemigoCL
@onready var agentenav: NavigationAgent2D = $NavigationAgent2D
@onready var respiracion: AudioStreamPlayer2D = $Respiracion

@export var objetivo : Node2D
const speed = 40
const accel = 5
func _ready() -> void:
	get_node("../../UI/Tracker").add_enemy(self)

func _process(delta):
	var direction =Vector3()
	agentenav.target_position = objetivo.global_position
	direction = agentenav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, accel* delta)
	move_and_slide()


func _on_area_perseguir_body_entered(body: Node2D) -> void:
	if body is JugadorOB:
		$Sprite2D.texture = load("res://Imagenes/Sprites/EnemigoAgro1.png")
		respiracion.play()
		$AreaPerseguir/CirculoSeguir.scale = Vector2(1.5,1.5)
		$Sorpresa.play()
		objetivo = get_node("../../Jugador")


func _on_area_perseguir_body_exited(body: Node2D) -> void:
	if body is JugadorOB:
		respiracion.stop()
		$Sprite2D.texture = load("res://Imagenes/Sprites/enemigo.png")
		$AreaPerseguir/CirculoSeguir.scale = Vector2(1,1)
		objetivo = get_node("../../Objetivo")

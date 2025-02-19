extends CharacterBody2D

func _ready() -> void:
	get_node("../Jugador/Tracker").add_enemy(self)

extends Area2D

@onready var interactuar: Area2D = $Sprite2D/Interactuar
@onready var luz: PointLight2D = $Luz
func _ready()->void:
	interactuar.interact = _al_usar

func _al_usar():
	if !luz.visible:
		luz.show()
		interactuar.puede_interactuar = false
	

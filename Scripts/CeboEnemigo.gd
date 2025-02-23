extends Node2D
var Posiciones = PackedVector2Array([Vector2(300, 490), Vector2(191, 309), Vector2(374,409)])
var index =0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	var temporal = index
	index= randi_range(0,2)
	if body is enemigoCL:
		print("index es "+str(index))
		self.position = Posiciones[index]

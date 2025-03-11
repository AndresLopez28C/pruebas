extends Node2D
var Posiciones = PackedVector2Array([Vector2(673, 248), Vector2(104, 109), Vector2(1085,333),
Vector2(60, 316),Vector2(687, 46),])
var index =0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	var temporal = index
	index= randi_range(0,4)
	if body is enemigoCL:
		print("index es "+str(index))
		self.position = Posiciones[index]

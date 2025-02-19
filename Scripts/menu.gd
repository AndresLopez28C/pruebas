extends Node2D
var peer = ENetMultiplayerPeer.new()
@export var escena_jugador : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_host_pressed() -> void:
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(unir)
	unir()

func unir(id =1):
	print("jugador unido")
	var player = escena_jugador.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)
	

func _on_btn_join_pressed() -> void:
	peer.create_client("localhost",135)
	multiplayer.multiplayer_peer = peer
	

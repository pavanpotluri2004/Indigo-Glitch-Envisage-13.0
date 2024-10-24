extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var spawn_point = get_node("SpawnPoint")
	player_data.respawn_position = spawn_point.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

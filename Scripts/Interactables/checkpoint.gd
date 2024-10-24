extends Area2D

signal checkpoint_reached(new_position: Vector2)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Player":
		player_data.respawn_position = position # Update the checkpoint position
		print(player_data.respawn_position)
		print("Checkpoint reached!")


#func _on_checkpoint_reached(new_position):
	#player_data.respawn_position = new_position

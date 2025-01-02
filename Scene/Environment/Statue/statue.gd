extends Node2D
@onready var control = $Control


func _on_body_entered(body):
	control.show()
	player_data.canInteract = true

func _on_body_exited(body):
	control.hide() 
	player_data.canInteract = false

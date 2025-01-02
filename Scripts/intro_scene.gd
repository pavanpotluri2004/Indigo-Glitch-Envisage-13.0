extends Node2D

func _ready():
	BackgroundMusic.playing = false
	
func _process(delta):
	if Input.is_mouse_button_pressed(3):
		BackgroundMusic.playing = true
		GameManager.start_new_game()

func _on_timer_timeout():
	BackgroundMusic.playing = true
	GameManager.start_new_game()

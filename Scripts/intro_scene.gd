extends Node2D

func _ready():
	BackgroundMusic.playing = false
	
func _process(delta):
	if Input.is_action_just_pressed("Skip"):
		_on_timer_timeout()

func _on_timer_timeout():
	GameManager.start_new_game()

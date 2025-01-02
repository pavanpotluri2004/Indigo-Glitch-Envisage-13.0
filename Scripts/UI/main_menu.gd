extends Control



func _on_start_pressed():
	GameManager.start_new_game()


func _on_options_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()

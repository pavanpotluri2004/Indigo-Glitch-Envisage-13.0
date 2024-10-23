extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$anim.play("Active")


func _on_body_entered(body):
	if body.name == "Player":
		$anim.play("Destroyed")
		player_data.coin += 1
		print("Amount of coins collected", player_data.coin)
		await $anim.animation_finished
		queue_free()

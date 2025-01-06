extends CharacterBody2D

@onready var interactAudio = $AudioStreamPlayer2D
@onready var animPlayer: AnimationPlayer = Transitions.get_node("AnimationPlayer")

var input
@export var speed=100.0
@export var gravity=10

# variable for jumping
var jump_count = 0
@export var max_jump = 2
@export var jumping_force = 500

#EVERYTHING RELATED TO STATE MACHINES
var current_state = player_states.MOVE
enum player_states {MOVE, SWORD, DEAD}

# Called when the node enters the scene tree for the first time.
func _ready():
	$sword/sword_collider.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match current_state:
		player_states.MOVE:
			movement(delta)
		player_states.SWORD:
			sword(delta)

func DialogueEnded():
	player_data.canMove = true
	interactAudio.stop()
	Dialogic.timeline_ended.disconnect(DialogueEnded)
	BackgroundMusic.play()

func movement(delta):
	if player_data.canInteract == true and Input.is_action_pressed("Interact") and player_data.interactedCount <= GameManager.current_level_index:
		if player_data.coin >= 4: #Change
			player_data.coin -= 4
			player_data.interactedCount += 1
			player_data.canInteract = false
			player_data.canMove = false
			interactAudio.play()
			BackgroundMusic.stop()
			Dialogic.timeline_ended.connect(DialogueEnded)
			Dialogic.start("statues" + str(GameManager.current_level_index + 1))
	
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input != 0 :
		if input > 0 :
			velocity.x +=speed * delta
			velocity.x = clamp(speed, 100.0, speed)
			$Sprite2D.scale.x = 1
			$sword.position.x = -5
			$anim.play("walk")
		if input < 0 :
			velocity.x -=speed * delta
			velocity.x = clamp(-speed, 100.0, -speed)
			$Sprite2D.scale.x = -1
			$sword.position.x = -40
			$anim.play("walk")
	if input == 0:
		velocity.x = 0
		$anim.play("idle") 
	
#code reated to jumping of the player

	if is_on_floor():
		jump_count = 0
		
	if !is_on_floor():
		if velocity.y < 0:
			$anim.play("jump")
		if velocity.y > 0:
			$anim.play("fall")
			
	if Input.is_action_just_pressed("ui_accept") && is_on_floor() && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jumping_force
		velocity.x = input
		
	if !is_on_floor() && Input.is_action_just_pressed("ui_accept") && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jumping_force * 1.2
		velocity.x = input
		
	if !is_on_floor() && Input.is_action_just_released("ui_accept") && jump_count < max_jump:
		velocity.y = gravity
		velocity.x = input
		
	else:
		gravity_force()
		
	if Input.is_action_just_pressed("ui_sword"):
		current_state = player_states.SWORD
	
	if player_data.canMove:
		gravity_force()
		move_and_slide()
	
func gravity_force():
	velocity.y += gravity

func sword(delta):
	$anim.play("sword")
	input_movement(delta)


func dead():
	
	$anim.play("dead")
	velocity.x = 0
	gravity_force()
	move_and_slide()
	await $anim.animation_finished
	animPlayer.play("FadeOut")
	await animPlayer.animation_finished
	GameManager.BackToIntro()
	current_state = player_states.MOVE  # Reset to MOVE state after respawning
	animPlayer.play("FadeIn")
	player_data.life = player_data.maxLife
	player_data.interactedCount = 0

func input_movement(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input != 0 :
		if input > 0 :
			velocity.x +=speed * delta
			velocity.x = clamp(speed, 100.0, speed)
			$Sprite2D.scale.x = 1
		if input < 0 :
			velocity.x -=speed * delta
			velocity.x = clamp(-speed, 100.0, -speed)
			$Sprite2D.scale.x = -1

	if input == 0:
		velocity.x=0
	gravity_force()
	move_and_slide()


func reset_states():
	current_state = player_states.MOVE


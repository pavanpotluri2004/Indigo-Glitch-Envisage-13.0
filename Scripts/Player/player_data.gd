extends Node2D
class_name player_data

static var coin = 0
static var maxLife = 4
static var life : int
static var respawn_position = Vector2()  # Store respawn position
static var has_checkpoint = false  # Track if a checkpoint was crossed

enum player_states {MOVE, SWORD, DEAD}

# Called when the node enters the scene tree for the first time.
func _ready():
	life = maxLife
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage_player(damage, player):
	life = life - damage
	if(life <= 0):
		player.current_state = player_states.DEAD
		player.dead()

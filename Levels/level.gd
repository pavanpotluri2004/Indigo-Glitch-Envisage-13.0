# level.gd
extends Node2D

func _ready():
	# Get reference to your player node when level starts
	var player = get_node("Player")  # Adjust path to match your player node
	if player:
		# Set player position based on entry direction
		player.position = GameManager.get_spawn_position()
	
	# Connect all exit areas
	setup_exit_areas()

func setup_exit_areas():
	# Connect signals for each exit area
	# Adjust node paths to match your level setup
	connect_exit_area("TopExit", GameManager.Direction.TOP)
	connect_exit_area("RightExit", GameManager.Direction.RIGHT)
	connect_exit_area("BottomExit", GameManager.Direction.BOTTOM)
	connect_exit_area("LeftExit", GameManager.Direction.LEFT)

func connect_exit_area(area_name: String, direction: GameManager.Direction):
	var exit_area = get_node_or_null(area_name)
	if exit_area:
		exit_area.body_entered.connect(
			func(body): _on_exit_area_entered(body, direction)
		)

func _on_exit_area_entered(body: Node2D, exit_direction: GameManager.Direction):
	if body.is_in_group("player"):
		GameManager.next_level(exit_direction)

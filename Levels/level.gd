# level.gd
extends Node2D

func _ready():
	# Get reference to your player node
	var player = get_node("Player")  # Adjust path to match your player node
	if player:
		# Get current level name
		var level_name = scene_file_path.get_file().get_basename()
		# Set player position based on entry direction and level-specific spawn point
		player.position = GameManager.get_spawn_position(level_name, GameManager.player_entry_direction)
	
	# Connect all exit areas
	setup_exit_areas()

func setup_exit_areas():
	# Connect signals for each exit area based on their actual positions in the level
	var level_name = scene_file_path.get_file().get_basename()
	
	# Get all Area2D nodes that are exits
	var exits = get_tree().get_nodes_in_group("level_exit")
	for exit in exits:
		# Determine exit direction based on position
		var exit_direction = determine_exit_direction(exit.global_position)
		exit.body_entered.connect(
			func(body): _on_exit_area_entered(body, exit_direction)
		)

func determine_exit_direction(pos: Vector2) -> GameManager.Direction:
	# Get viewport size for reference
	var viewport_size = get_viewport_rect().size
	var margin = 50  # Margin to determine if position is at edge
	
	# Determine direction based on position
	if pos.y < margin:
		return GameManager.Direction.TOP
	elif pos.x > viewport_size.x - margin:
		return GameManager.Direction.RIGHT
	elif pos.y > viewport_size.y - margin:
		return GameManager.Direction.BOTTOM
	else:
		return GameManager.Direction.LEFT

func _on_exit_area_entered(body: Node2D, exit_direction: GameManager.Direction):
	if body.is_in_group("player"):
		GameManager.next_level(exit_direction)

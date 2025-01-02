# game_manager.gd
extends Node

enum Direction { TOP, RIGHT, BOTTOM, LEFT }
var current_level_index: int = 0
var level_sequence: Array = []
var player_entry_direction: Direction

# Dictionary to store spawn positions for each direction
var spawn_positions = {
	Direction.TOP: Vector2(264, 8),     # Bottom of screen
	Direction.RIGHT: Vector2(416, 203),   # Left of screen
	Direction.BOTTOM: Vector2(144, 216),    # Top of screen
	Direction.LEFT: Vector2(0, 180)    # Right of screen
}

func _ready():
	start_new_game()

func start_new_game():
	current_level_index = 0
	level_sequence = [
		"res://levels/level_2_test1.tscn",
		"res://levels/level_2_test2.tscn",
		"res://levels/level_2_test3.tscn",
		"res://levels/level_2_test4.tscn",
		"res://levels/level_2_test6.tscn"
	]
	# Shuffle the array for random order
	level_sequence.shuffle()
	load_current_level(Direction.TOP)  # Default first entry

func load_current_level(entry_direction: Direction):
	if current_level_index < level_sequence.size():
		player_entry_direction = entry_direction
		get_tree().change_scene_to_file(level_sequence[current_level_index])
	else:
		print("Game Completed!")

func next_level(exit_direction: Direction):
	current_level_index += 1
	# Player will enter from the opposite direction they exited
	var entry_direction = get_opposite_direction(exit_direction)
	load_current_level(entry_direction)

func get_opposite_direction(direction: Direction) -> Direction:
	match direction:
		Direction.TOP: return Direction.BOTTOM
		Direction.RIGHT: return Direction.LEFT
		Direction.BOTTOM: return Direction.TOP
		Direction.LEFT: return Direction.RIGHT
		_: return Direction.TOP

func get_spawn_position() -> Vector2:
	return spawn_positions[player_entry_direction]

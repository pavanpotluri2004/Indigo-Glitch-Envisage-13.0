extends Node

class_name LevelOrderGenerator

# Store level paths/identifiers
var levels = [
	"res://Levels/level_2_test1.tscn",
	"res://Levels/level_2_test2.tscn",
	"res://Levels/level_2_test3.tscn",
	"res://Levels/level_2_test4.tscn",
	"res://Levels/level_2_test6.tscn"
]

# Grid size for random walker (larger grid = more randomness)
const GRID_SIZE = 10
var grid: Array
var current_pos: Vector2
var available_positions: Array
var level_order: Array

func _init():
	randomize() # Initialize random number generator

func generate_level_order() -> Array:
	# Initialize grid
	grid = []
	level_order = []
	available_positions = []
	
	# Create grid
	for x in range(GRID_SIZE):
		grid.append([])
		for y in range(GRID_SIZE):
			grid[x].append(-1)  # -1 means unvisited
			available_positions.append(Vector2(x, y))
	
	# Start from random position
	current_pos = available_positions[randi() % available_positions.size()]
	
	# Place levels using random walker
	for i in range(levels.size()):
		# Mark current position with level index
		grid[current_pos.x][current_pos.y] = i
		level_order.append(levels[i])
		
		# Get next position if not all levels are placed
		if i < levels.size() - 1:
			current_pos = get_next_position()
	level_order.shuffle()
	return level_order

func get_next_position() -> Vector2:
	var possible_moves = []
	var directions = [
		Vector2(0, 1),   # Down
		Vector2(0, -1),  # Up
		Vector2(1, 0),   # Right
		Vector2(-1, 0)   # Left
	]
	
	# Check all possible moves
	for dir in directions:
		var new_pos = current_pos + dir
		if is_valid_position(new_pos):
			possible_moves.append(new_pos)
	
	# If no valid moves, jump to random unvisited position
	if possible_moves.size() == 0:
		var unvisited = []
		for x in range(GRID_SIZE):
			for y in range(GRID_SIZE):
				if grid[x][y] == -1:
					unvisited.append(Vector2(x, y))
		
		if unvisited.size() > 0:
			return unvisited[randi() % unvisited.size()]
	
	# Return random valid move
	return possible_moves[randi() % possible_moves.size()]

func is_valid_position(pos: Vector2) -> bool:
	# Check if position is within grid bounds and unvisited
	return (pos.x >= 0 and pos.x < GRID_SIZE and 
			pos.y >= 0 and pos.y < GRID_SIZE and 
			grid[pos.x][pos.y] == -1)

# Example usage function
func get_shuffled_levels() -> Array:
	return generate_level_order()

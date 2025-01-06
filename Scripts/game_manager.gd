# game_manager.gd
extends Node

enum Direction { TOP, RIGHT, BOTTOM, LEFT }
var current_level_index: int = 0
var level_sequence: Array = []
var player_entry_direction: Direction

@onready var animPlayer: AnimationPlayer = Transitions.get_node("AnimationPlayer")
@onready var loopTimer: Timer = Transitions.get_node("Timer")

# Dictionary to store spawn and exit positions for each level
# Format: level_name: { 
#   "spawns": { Direction: Vector2 },
#   "exits": { Direction: Vector2 }
# }
var level_data = {
	"level_2_test1": {
		"spawns": {
			Direction.TOP: Vector2(264, 32),     # Example position
			Direction.RIGHT: Vector2(360, 192),
			Direction.BOTTOM: Vector2(155, 187),
			Direction.LEFT: Vector2(8, 176)
		},
		"exits": {
			Direction.TOP: Vector2(280, -16),
			Direction.RIGHT: Vector2(439, 203),
			Direction.BOTTOM: Vector2(166, 240),
			Direction.LEFT: Vector2(0, 187)
		}
	},
	"level_2_test2": {
		"spawns": {
			Direction.TOP: Vector2(1236, -16),     # Different positions for level 2
			Direction.RIGHT: Vector2(424, 56),
			Direction.BOTTOM: Vector2(312, 192),
			Direction.LEFT: Vector2(16, 100)
		},
		"exits": {
			Direction.TOP: Vector2(138, -32),
			Direction.RIGHT: Vector2(448, 49),
			Direction.BOTTOM: Vector2(344, 256),
			Direction.LEFT: Vector2(-24, 92)
		}
	},
	# Add data for your other levels here
	"level_2_test3": {
		"spawns": {
			Direction.TOP: Vector2(272, 0),     # Different positions for level 2
			Direction.RIGHT: Vector2(424, 103),
			Direction.BOTTOM: Vector2(88, 185),
			Direction.LEFT: Vector2(0, 92)
		},
		"exits": {
			Direction.TOP: Vector2(299, -32),
			Direction.RIGHT: Vector2(448, 104),
			Direction.BOTTOM: Vector2(91, 256),
			Direction.LEFT: Vector2(-32, 95)
		}
	},

	"level_2_test4": {
		"spawns": {
			Direction.TOP: Vector2(272, -8),     # Different positions for level 2
			Direction.RIGHT: Vector2(360, 187),
			Direction.BOTTOM: Vector2(180, 192),
			Direction.LEFT: Vector2(0, 112)
		},
		"exits": {
			Direction.TOP: Vector2(264, -32),
			Direction.RIGHT: Vector2(408, 220),
			Direction.BOTTOM: Vector2(155, 256),
			Direction.LEFT: Vector2(-32, 112)
		}
	},

	"level_2_test6": {
		"spawns": {
			Direction.TOP: Vector2(96, -8),     # Different positions for level 2
			Direction.RIGHT: Vector2(376, 120),
			Direction.BOTTOM: Vector2(224, 189),
			Direction.LEFT: Vector2(0, 72)
		},
		"exits": {
			Direction.TOP: Vector2(96, -32),
			Direction.RIGHT: Vector2(448, 161),
			Direction.BOTTOM: Vector2(220, 256),
			Direction.LEFT: Vector2(-32, 67)
		}
	},
}

# func LoopTimer():
	# get_tree().change_scene_to_file("res://Scene/intro_scene.tscn")

func _ready():
	Dialogic.signal_event.connect(GameOver)
	
func BackToIntro():
	get_tree().change_scene_to_file("res://Scene/intro_scene.tscn
	")

func start_new_game():
	
	# loopTimer.timeout.connect(LoopTimer)
	# loopTimer.start()
	
	
	BackgroundMusic.playing = true
	current_level_index = 0
	level_sequence = [
		"res://levels/level_2_test1.tscn",
		"res://levels/level_2_test2.tscn",
		"res://levels/level_2_test3.tscn",
		"res://levels/level_2_test4.tscn",
		"res://levels/level_2_test6.tscn"
	]
	level_sequence.shuffle()
	
	# This is a Hack
	if level_sequence[0] == "res://levels/level_2_test2.tscn":
		var temp = level_sequence[1]
		level_sequence[1] = level_sequence[0]
		level_sequence[0] = temp
	# Fix this with an implementation that can have 2 as a start level	
	load_current_level(Direction.TOP)  # Default first entry

func get_level_name_from_path(path: String) -> String:
	# Extract level name from path (e.g., "level_2_test1" from "res://levels/level_2_test1.tscn")
	return path.get_file().get_basename()

func get_spawn_position(level_name: String, entry_direction: Direction) -> Vector2:
	if level_data.has(level_name) and level_data[level_name]["spawns"].has(entry_direction):
		return level_data[level_name]["spawns"][entry_direction]
	else:
		push_error("Missing spawn data for level: " + level_name)
		return Vector2(300, 300)  # Default fallback position

func load_current_level(entry_direction: Direction):
	player_entry_direction = entry_direction
	animPlayer.play("FadeOut")
	await animPlayer.animation_finished
	get_tree().change_scene_to_file(level_sequence[current_level_index])
	animPlayer.play("FadeIn")
	

func next_level(exit_direction: Direction):
	current_level_index = current_level_index + 1 if player_data.interactedCount == current_level_index + 1 else current_level_index
	current_level_index = min(level_sequence.size() - 1, current_level_index)
	var entry_direction = get_opposite_direction(exit_direction)
	
	load_current_level(entry_direction)

func get_opposite_direction(direction: Direction) -> Direction:
	match direction:
		Direction.TOP: return Direction.BOTTOM
		Direction.RIGHT: return Direction.LEFT
		Direction.BOTTOM: return Direction.TOP
		Direction.LEFT: return Direction.RIGHT
		_: return Direction.TOP
func respawn_player_in_current_level(exit_direction: Direction):
	# Get the player node
	var player = get_tree().get_first_node_in_group("player")
	if player:
		# Get the current level name
		var current_level_name = get_level_name_from_path(level_sequence[current_level_index])
		
		# Get the spawn position for the opposite direction
		var entry_direction = get_opposite_direction(exit_direction)
		var spawn_pos = get_spawn_position(current_level_name, entry_direction)
		
		# Optional: Add a respawn effect
		create_respawn_effect(player.position, spawn_pos)
		
		# Move player to new spawn position
		player.position = spawn_pos

func create_respawn_effect(old_pos: Vector2, new_pos: Vector2):
	# Create a simple fade effect
	var canvas_layer = CanvasLayer.new()
	var fade_rect = ColorRect.new()
	
	add_child(canvas_layer)
	canvas_layer.add_child(fade_rect)
	
	fade_rect.color = Color(0, 0, 0, 0)  # Start transparent
	fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# Fade out
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, 0.2)  # Fade to black
	await tween.finished
	
	# Move player
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.position = new_pos
	
	# Fade in
	tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, 0.2)  # Fade to transparent
	await tween.finished
	
	# Clean up
	canvas_layer.queue_free()


func GameOver(argument: String):
	print("Done")
	if argument == "GameOver":
		print("Done2")
		Transitions.get_node("Label").show()
		animPlayer.play("FadeOutGameOver")
		await animPlayer.animation_finished
		get_tree().change_scene_to_file("res://Scene/Main Menu/main_menu.tscn")
		animPlayer.play("FadeIn")
		Transitions.get_node("Label").hide()
		

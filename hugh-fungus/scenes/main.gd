extends Node2D

var current_level = null

func load_level(level_path: String, spawn_position: Vector2):
	# Remove previous level if any
	if current_level:
		current_level.queue_free()

	# Load the new level
	var level_scene = load(level_path).instantiate()
	$levelContainer.add_child(level_scene)
	current_level = level_scene

	# Set player position
	$player.global_position = spawn_position



func _ready():
	load_level("res://scenes/level_1.tscn",Vector2(2905.0, -130.0079))
	
	#hugh is loaded in ear shot of the bear and the mushroom alter 
	#cant figure out dialogue and im burning time.. gonna fill out more game elements
	

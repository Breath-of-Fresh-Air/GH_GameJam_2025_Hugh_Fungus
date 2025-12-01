extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.is_level_1 = false
	GameState.is_level_2 = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

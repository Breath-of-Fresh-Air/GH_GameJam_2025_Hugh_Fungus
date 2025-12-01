extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$bgMusic.play_area_track($bgMusic.ground_playlist)
	GameState.is_level_1 = true
	GameState.is_level_2 = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

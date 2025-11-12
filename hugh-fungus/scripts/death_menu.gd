extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#change this from player health to a signal from the player its anims are done 
	if PlayerHealthGlobal.player_health <= 0:
		self.visible = true
	else:
		self.visible = false

func _on_reset_button_button_up() -> void:
	get_tree().reload_current_scene()
	PlayerHealthGlobal.player_health = 5

func _on_quit_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

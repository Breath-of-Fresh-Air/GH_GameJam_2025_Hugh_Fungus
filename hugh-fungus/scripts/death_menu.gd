extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#change this from player health to a signal from the player its anims are done 
	if PlayerHealthGlobal.player_health <= 0:
		self.visible = true
		get_tree().paused = true
	
		

func _on_reset_button_button_up() -> void:
	
	PlayerHealthGlobal.player_health = 5
	get_tree().reload_current_scene()
	
func _on_quit_button_button_up() -> void:
	PlayerHealthGlobal.player_health = 5
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
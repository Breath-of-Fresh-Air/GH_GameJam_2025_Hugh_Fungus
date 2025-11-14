extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("pause"):
		self.visible = true
		get_tree().paused = true


func _on_resume_button_button_up() -> void:
	get_tree().paused = false
	self.visible = false


func _on_quit_button_button_up() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

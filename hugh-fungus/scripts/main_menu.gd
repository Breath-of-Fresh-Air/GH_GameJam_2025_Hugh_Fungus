extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_controls_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/controls_scene.tscn")

func _on_quit_button_button_up() -> void:
	get_tree().quit()



func _on_settings_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")


func _on_credits_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/credits_scene.tscn")

extends Control
@onready var settings_menu = $settings_menu
@onready var credits_menu = $credits_scene
@onready var controls_menu = $Controls_scene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$bgMusic.play_area_track($bgMusic.mainMenu_playlist)
	settings_menu.visible = false
	credits_menu.visible = false
	controls_menu.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")


func _on_controls_button_button_up() -> void:
	controls_menu.visible = true

func _on_quit_button_button_up() -> void:
	get_tree().quit()



func _on_settings_button_up() -> void:
	settings_menu.visible = true

func _on_credits_button_up() -> void:
	credits_menu.visible = true

extends Node2D

@onready var item_1 = $mycelium1
@onready var item_2 = $mycelium2
@onready var item_3 = $mycelium3
@onready var label1 = $Control/Label
@onready var enter_label = $Control/enter_label
var can_minigame
var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_1.visible = false
	item_2.visible = false
	item_3.visible = false
	label1.visible = false
	enter_label.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	



	if player:
		if can_minigame:
			
			enter_label.visible = true
			label1.visible = false
			if Input.is_action_just_pressed("interact"):
				get_tree().change_scene_to_file("res://scenes/EM_Waves_Minigame.tscn")
		else:
			label1.visible = true
		if Input.is_action_just_pressed("interact") :
			if MyceliumTracker.items_collected == 1:
				item_1.visible = true
			elif MyceliumTracker.items_collected == 2:
				item_1.visible = true
				item_2.visible = true
			elif MyceliumTracker.items_collected == 3:
				item_1.visible = true
				item_2.visible = true
				item_3.visible = true
				can_minigame = true
			

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
			
			
func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		label1.visible = false
		enter_label.visible = false

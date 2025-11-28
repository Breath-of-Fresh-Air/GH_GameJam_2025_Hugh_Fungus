extends Node2D
@onready var honey_jar = $Sprite2D
var player
var bear
var jar_placed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	honey_jar.visible = false
	$Control/place_label/Label.visible = false
	MyceliumTracker.honey_taget_pos = self.global_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	display_msg()
	if MyceliumTracker.honey_jar_collected == true:

		handle_player_interact()
	
	if jar_placed:
		
		MyceliumTracker.honey_jar_placed = true
	if bear:
		MyceliumTracker.bear_arrived = true

	if MyceliumTracker.bear_finished == true:
		self.queue_free()
func handle_player_interact():
	if Input.is_action_just_pressed("interact"):
		honey_jar.visible = true
		jar_placed = true


func display_msg():
	if player != null:
		if MyceliumTracker.honey_jar_collected == true:
			$Control/place_label/Label.visible = true
		else:
			$Control/place_label/Label.visible = false
	else:
		$Control/place_label/Label.visible = false

func _on_player_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		
	if body.is_in_group("sleeping_bear"):
		bear = body
func _on_player_detect_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		
	if body.is_in_group("sleeping_bear"):
		bear = null
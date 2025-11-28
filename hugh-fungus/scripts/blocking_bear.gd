extends CharacterBody2D
var direction
var player
var target_pos 
const SPEED = 30

@onready var current_state = state.IDLE
@onready var anim_sprite = $AnimatedSprite2D

enum state {
	IDLE,
	WALK,
	END,
	}


func _ready() -> void:
	$Control/sleep_label/Label.visible = false
	$Control/hungry_label/Label.visible = false
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if MyceliumTracker.honey_jar_placed == true:
		target_pos = MyceliumTracker.honey_taget_pos
		if target_pos != null:
			current_state = state.WALK
	if MyceliumTracker.bear_arrived == true:
		current_state = state.END
	match current_state:
		state.IDLE:
			handle_idle(delta)
		state.WALK:
			handle_walk(delta)
		state.END:
			handle_end(delta)
	move_and_slide()


func handle_idle(delta):
	handle_snooze()
	velocity = Vector2.ZERO
	anim_sprite.play("idle")
	


func handle_walk(delta):
	
	direction = (target_pos - self.global_position).normalized()
	velocity = direction * SPEED
	anim_sprite.play("walk")

func handle_end(delta):
	velocity = Vector2.ZERO
	anim_sprite.play("end")
	MyceliumTracker.bear_finished = true


func handle_snooze():
	if player != null:
		
		if MyceliumTracker.honey_jar_collected == true:
			$Control/hungry_label/Label.visible = true
		else:
			$Control/sleep_label/Label.visible = true
	else:
		$Control/hungry_label/Label.visible = false
		$Control/sleep_label/Label.visible = false

func _on_player_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		handle_snooze()


func _on_player_detect_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		handle_snooze()

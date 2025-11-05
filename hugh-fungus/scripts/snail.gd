extends CharacterBody2D



const JUMP_VELOCITY = -400.0
var player_detected = false
var direction
var player
var SPEED = 70

 
enum state {
	IDLE,
	CHASE,
	WANDER,
	ATTACK,
	}
@onready var current_state = state.IDLE
@onready var idle_timer : Timer =  $idle_timer
@onready var wander_timer : Timer = $rand_Move_Timer
func _ready() -> void:
	
	idle_timer.start()
func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	
	match current_state:
		state.IDLE:
			handle_idle(delta)
		state.WANDER:
			handle_wander(delta)
		state.ATTACK:
			handle_attack(delta)
		state.CHASE:
			handle_chase(delta)
	move_and_slide()
	
	
		
	
func handle_idle(delta):
	velocity = Vector2.ZERO
	if not is_on_floor():
		velocity += get_gravity() * delta
	

func handle_chase(delta):
	if player_detected == true:
		direction.x =  (player.global_position - self.global_position).normalized()
		velocity = direction.x * SPEED
		if not is_on_floor():
			velocity += get_gravity() * delta
		if player.global_position.distance_to(self.global_position) <= 20.00:
			current_state = state.ATTACK
	else:
		velocity = Vector2.ZERO
		current_state = state.IDLE

func handle_wander(delta):
	if player_detected:
		current_state = state.CHASE
		return
	
	velocity = direction.x * SPEED
	if not is_on_floor():
		velocity += get_gravity() * delta

func flip_direction():
	if direction.x == -1:
		direction.x = 1
	else:
		direction.x = -1
	
	


func handle_attack(delta):
	
	$enemy_hitbox.visible = false
	$attack_cooldow_timer.start()
	$enemy_hitbox.visible = true
	velocity = Vector2.ZERO
	if not is_on_floor():
		velocity += get_gravity() * delta
	#add cooldown timer for attack 


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_detected = true
		player = body
		current_state = state.CHASE 
		
func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_detected = false
		player = null
		current_state = state.IDLE
	


func _on_rand_move_timer_timeout() -> void:
	current_state = state.IDLE
	idle_timer.start()

func _on_idle_timer_timeout() -> void:
	current_state = state.WANDER
	flip_direction()
	wander_timer.start()


func _on_attack_cooldow_timer_timeout() -> void:
	$enemy_hitbox.visible = false
	current_state = state.IDLE

	
	

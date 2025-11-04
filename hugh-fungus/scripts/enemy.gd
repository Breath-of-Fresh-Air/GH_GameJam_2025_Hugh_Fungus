extends CharacterBody2D
var player_detected = false
var direction
var player
var SPEED = 70
var random_direction
 
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
	
	
		
	
func handle_idle(_delta):
	velocity = Vector2.ZERO
	
	

func handle_chase(_delta):
	if player_detected == true:
		direction =  (player.global_position - self.global_position).normalized()
		velocity = direction * SPEED
		if player.global_position.distance_to(self.global_position) <= 20.00:
			current_state = state.ATTACK
	else:
		velocity = Vector2.ZERO
		current_state = state.IDLE

func handle_wander(_delta):
	if player_detected:
		current_state = state.CHASE
		return
	
	velocity = random_direction * SPEED
	

func randomize_direction():
	
	var x = randf_range(-1.0,1.0)
	var y = randf_range(-1.0,1.0)
	random_direction = Vector2(x,y).normalized()


func handle_attack(_delta):
	
	$enemy_hitbox.visible = false
	$attack_cooldow_timer.start()
	$enemy_hitbox.visible = true
	velocity = Vector2.ZERO
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
	randomize_direction()
	wander_timer.start()


func _on_attack_cooldow_timer_timeout() -> void:
	$enemy_hitbox.visible = false
	current_state = state.IDLE

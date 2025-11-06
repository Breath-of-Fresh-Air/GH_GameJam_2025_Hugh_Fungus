extends CharacterBody2D
#things work well i might come back to this
#feel free to mess with speed and whatnot -M
var player_detected = false
var direction = 1
var player
var SPEED = 70
#states
enum state {
	IDLE,
	WANDER,
	ATTACK,
	DEATH,
	}
	#set current state,start timers on ready
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
		state.DEATH:
			handle_death(delta)
	move_and_slide()
	
	
		
#idle function 
func handle_idle(delta):
	#stop movement
	velocity = Vector2.ZERO
	#Check gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
#wander function 
func handle_wander(delta):
	#move snail
	velocity.x = direction * SPEED
	#check gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

#flip the snails direction
func flipping_direction():
	if is_on_wall():
		direction *= -1
		if direction == -1:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true

#attack function
func handle_attack(delta):
	#put ATTACK ANIMS
	

	if not is_on_floor():
		velocity += get_gravity() * delta
	 

#death function
func handle_death(_delta):
	# add death anims

	# await anim finished then quefree
	self.queue_free()

# declare the player body and change state to attack
func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_detected = true
		player = body
		current_state = state.ATTACK 
		

#declare player is null	
func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_detected = false
		player = null
		current_state = state.IDLE
	
#on move timer end change state
func _on_rand_move_timer_timeout() -> void:
	current_state = state.IDLE
	idle_timer.start()

#on Idle timer end change state and flip direction
func _on_idle_timer_timeout() -> void:
	current_state = state.WANDER
	flipping_direction()
	wander_timer.start()

#attack timer end change state,make hitbox invisible 
func _on_attack_cooldow_timer_timeout() -> void:
	$enemy_hitbox.visible = false
	current_state = state.IDLE

#declare player is body, state death
func _on_player_detect_top_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		if player.velocity.y > 0:
			current_state = state.DEATH

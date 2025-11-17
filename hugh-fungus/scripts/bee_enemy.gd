extends CharacterBody2D
var bee_health = 5 
var random_direction
var player_pos
var player_initPOS
var player
var distance
@onready var current_state = state.WANDER
@onready var stun_time = $stun_timer
const SPEED = 40
var chase_speed = 60
var attck_speed = 100
enum state {
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	HURT,
	DEATH,
	}
func _ready():
	randomize_direction()

func _physics_process(delta: float) -> void:
	if player != null:
		check_distance()
		
	print("state =", current_state, "health",bee_health, "distance", distance)
	match current_state:
		state.IDLE:
			handle_idle(delta)
		state.WANDER:
			handle_wander(delta)
		state.CHASE:
			handle_chase(delta)
		state.ATTACK:
			handle_attack(delta)
		state.HURT:
			handle_hurt(delta)
		state.DEATH:
			handle_death(delta)
	move_and_slide()
 
	

func handle_idle(_delta):
	stun_time.start()
	$AnimatedSprite2D.play("Bee_base")
	if random_direction.x < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	velocity = Vector2.ZERO

func handle_wander(_delta):

	$AnimatedSprite2D.play("Bee_base")
	if random_direction.x < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	#check for floor
	if self.is_on_floor():
		randomize_direction()
	#check for walls
	elif self.is_on_wall():
		randomize_direction()
	elif self.is_on_ceiling():
		randomize_direction()
	velocity = random_direction * SPEED


func handle_chase(_delta):
	var chase_direction = (player.global_position - self.global_position).normalized()
	$AnimatedSprite2D.play("Bee_agro")
	if chase_direction.x < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	velocity = chase_direction * chase_speed


func handle_attack(_delta):
	if self.is_on_floor():
		current_state = state.HURT
	if is_on_wall():
		current_state = state.HURT
	var direction = (player_initPOS - self.global_position).normalized()
	$AnimatedSprite2D.play("Bee_agro")
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	velocity = direction * attck_speed


func handle_hurt(_delta):
	#play hurt anim 
	#subtract health
	
	if bee_health >= 0:
		current_state = state.IDLE
		bee_health -= 1
	else: 
		#change state
		current_state = state.DEATH

func handle_death(_delta):
	self.queue_free()

func randomize_direction():
	
	var x = randf_range(-1.0,1.0)
	var y = randf_range(-1.0,1.0)
	random_direction = Vector2(x,y).normalized()


func check_distance():
	distance = global_position.distance_to(player.global_position)
	if distance < 25:
		current_state = state.HURT
	elif distance >=26 and distance <= 50:
		player_initPOS = player.global_position
		current_state = state.ATTACK

	elif distance >=50:
		current_state = state.CHASE
		player_pos = player.global_position
		


func _on_change_dir_timer_timeout() -> void:
	randomize_direction()
	current_state = state.WANDER

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		current_state = state.IDLE

func _on_stun_timer_timeout() -> void:
	
		current_state = state.WANDER

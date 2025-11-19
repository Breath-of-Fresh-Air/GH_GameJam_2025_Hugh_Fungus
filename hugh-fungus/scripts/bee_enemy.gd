extends CharacterBody2D
#knockback 
@onready var anim_sprite = $AnimatedSprite2D
var knockback_power =400.0
var knockback_duration = 3.0
var knockback_active = false
var knockback_timer = 0.0
var bee_health = 5 
var random_direction
var player_pos
var player_initPOS
var hurt_pos
var player
var distance
var is_idle = false
var idle_duration = 2.0
var idle_timer = 0.0
@onready var current_state = state.WANDER
var chase_direction
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
	if is_idle:
		idle_timer -= delta
		if idle_timer <= 0:
			is_idle = false

	if knockback_active:
		knockback_timer -= delta
		# 
		if knockback_timer <= 0:
			knockback_active = false
		
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
	if idle_timer <= 0:
		current_state = state.WANDER
	
	$AnimatedSprite2D.play("Bee_base")
	if random_direction.x < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	velocity = Vector2.ZERO
	
func handle_wander(_delta):
	idle_timer = idle_duration
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
	chase_direction = (player_pos - self.global_position).normalized()
	$AnimatedSprite2D.play("Bee_agro")
	if chase_direction.x < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	
	velocity = chase_direction * chase_speed


func handle_attack(_delta):
	var direction = (player_initPOS - self.global_position).normalized()
	$AnimatedSprite2D.play("Bee_agro")
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	velocity = direction * attck_speed


func handle_hurt(_delta):
	#play hurt anim 
	if bee_health >= 0:
		#subtract health
		# add knockback
		knockback(hurt_pos)
		is_idle = true
		current_state = state.IDLE
		
	else: 
		#change state
		current_state = state.DEATH

func handle_death(_delta):
	self.queue_free()

func randomize_direction():
	
	var x = randf_range(-1.0,1.0)
	var y = randf_range(-1.0,1.0)
	random_direction = Vector2(x,y).normalized()



	
#KNOCKBACK BABY!!!
func knockback(knockback_source: Vector2):
	knockback_active = true
	bee_health -= 1

	var knockback_dir = (self.global_position - knockback_source).normalized()
	
	# Fallback if the player is exactly on top of the enemy
	if knockback_dir == Vector2.ZERO:
		# Use the opposite of the player’s facing direction
		knockback_dir = Vector2(-1 if anim_sprite.flip_h else 1, 0)
	# add a little vertical kick
	var knockback_vector = knockback_dir * knockback_power

	velocity = knockback_vector
	#reset timer
	knockback_timer = knockback_duration


		


func _on_change_dir_timer_timeout() -> void:
	randomize_direction()
	

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		player_pos = player.global_position
		current_state = state.CHASE


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		is_idle = true
		current_state = state.IDLE

func _on_hurt_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		hurt_pos = player.global_position
		current_state = state.HURT

func _on_attack_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		player_initPOS = player.global_position
		current_state = state.ATTACK



		

func _on_attack_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		current_state = state.CHASE

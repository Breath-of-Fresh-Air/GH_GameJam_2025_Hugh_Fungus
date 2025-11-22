extends CharacterBody2D
#knockback 
var knockback_power = 300.0
var knockback_duration = 0.6
var knockback_active = false
var knockback_timer = 0.0
var knockback_dir
# bee health
var bee_health = 5 
# directions / speeds
const SPEED = 40
var chase_speed = 60
var attck_speed = 140
var random_direction
var chase_direction
var attack_dir
var direction = 1
# player references 
var player
var player_pos
var player_initPOS
var hurt_pos
# idle stuff
var is_idle = false
var idle_duration = 2.0
var idle_timer = 0.0
#hurt check
var is_hurt = false


@onready var current_state = state.WANDER
@onready var anim_sprite = $AnimatedSprite2D

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
	if bee_health <= 0:
			current_state = state.DEATH
	if is_idle:
		idle_timer -= delta
		if idle_timer <= 0:
			is_idle = false
	
	
	if knockback_active:
		knockback_timer -= delta
		# 
		if knockback_timer <= 0:
			
			knockback_active = false
			current_state = state.WANDER
		
	
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
	is_idle = true
	if idle_timer <= 0:
		current_state = state.WANDER
	$AnimatedSprite2D.play("Bee_base")
	velocity = Vector2.ZERO
	
func handle_wander(_delta):
	
	idle_timer = idle_duration
	$AnimatedSprite2D.play("Bee_base")
	if direction.x >= 0:
		anim_sprite.flip_h = true
	else:
		anim_sprite.flip_h = false
	#check for floor
	if self.is_on_floor():
		randomize_direction()
	#check for walls
	elif self.is_on_wall():
		randomize_direction()
	elif self.is_on_ceiling():
		randomize_direction()
	velocity = direction * SPEED
	

func handle_chase(_delta):
	if player:
		direction = (player.global_position - self.global_position).normalized()
	
	$AnimatedSprite2D.play("Bee_agro")
	if direction.x >= 0:
		anim_sprite.flip_h = true
	else:
		anim_sprite.flip_h = false
	velocity = direction * chase_speed


func handle_attack(_delta):
	if player:
		direction = (player_initPOS - self.global_position).normalized()
	
	$AnimatedSprite2D.play("Bee_agro")
	if direction.x >= 0:
		anim_sprite.flip_h = true
	else:
		anim_sprite.flip_h = false
	velocity = direction * attck_speed


func handle_hurt(_delta):
	
		if player:
			knockback(player.global_position)
			#play hurt anim
			anim_sprite.play("Bee_hurt")
			if knockback_dir.x >= 0:
				anim_sprite.flip_h = true
			else:
				anim_sprite.flip_h = false
	
	
	 
	
		

func handle_death(_delta):
	$AnimatedSprite2D.play("Bee_death")
	await $AnimatedSprite2D.animation_finished
	if $AnimatedSprite2D.animation_finished:
		self.queue_free()

func randomize_direction():
	var x = randf_range(-1.0,1.0)
	var y = randf_range(-1.0,1.0)
	random_direction = Vector2(x,y).normalized()
	direction = random_direction


	
#KNOCKBACK BABY!!!
func knockback(knockback_source: Vector2):
	knockback_active = true
	knockback_dir = (self.global_position - knockback_source).normalized()
	# Fallback if the player is exactly on top of the enemy
	if knockback_dir == Vector2.ZERO:
		# Use the opposite of the player’s facing direction
		knockback_dir = Vector2(-1 if anim_sprite.flip_h else 1, 0)
	# add a little vertical kick
	var knockback_vector = knockback_dir * knockback_power
	knockback_vector.y = -abs(knockback_power) * 0.3
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
		$player_detector.visible = false
		$attack_zone.visible = false
		player = body
		
		bee_health -=1
		
		current_state = state.HURT


func _on_attack_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$player_detector.visible = false
		player = body
		player_initPOS = player.global_position
		current_state = state.ATTACK
			


		

func _on_attack_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$player_detector.visible = true
		current_state = state.CHASE
			


func _on_hurt_detect_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if knockback_active == false:
			$attack_zone.visible = true
			$player_detector.visible = true
			current_state = state.IDLE
			

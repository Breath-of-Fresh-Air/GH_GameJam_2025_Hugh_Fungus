extends CharacterBody2D
#knockback
var knockback_power = 300.0
var knockback_duration = 0.6
var knockback_active = false
var knockback_timer = 0.0
var knockback_dir
# bee health
var bunny_health = 5
var amount_dropped = 0
# directions / speeds
const SPEED = 60
var chase_speed = 80
var chase_direction
var direction = 1
# player references
var player
var player_pos
var hurt_pos
# idle stuff
var is_idle = false
var idle_duration = 2.0
var idle_timer = 0.0
#hurt check
var is_hurt = false
#wander_hop
var wander_jpower = -100
var wander_gravity = 400
var wander_timer = 0.0
var wander_duration = 3.0
#attack stuff
var attack_gravity = 400
var attack_jpower = -200
@onready var current_state = state.IDLE
@onready var anim_sprite = $AnimatedSprite2D
@onready var spawn_point = $health_spawn_point
@export var health_drop: PackedScene

enum state {
	IDLE,
	WANDER,
	CHASE,
	HURT,
	DEATH,
	}


func _physics_process(delta: float) -> void:

	

	if bunny_health <= 0:
			current_state = state.DEATH





	if knockback_active:
		knockback_timer -= delta
		#
		if knockback_timer <= 0:

			knockback_active = false
			current_state = state.IDLE

	
	match current_state:
		state.IDLE:
			handle_idle(delta)
		state.WANDER:
			handle_wander(delta)
		state.CHASE:
			handle_chase(delta)
		state.HURT:
			handle_hurt(delta)
		state.DEATH:
			handle_death(delta)
	move_and_slide()

func handle_idle(delta):
	if is_on_floor():
		velocity = Vector2.ZERO
	velocity.y += attack_gravity * delta
	
	
	# Start idle timer only once
	if idle_timer <= 0:
		idle_timer = idle_duration

	idle_timer -= delta

	if idle_timer <= 0:
		# exit idle
		flipping_direction()
		current_state = state.WANDER

func handle_wander(delta):
	if wander_timer <= 0:
		wander_timer = wander_duration
	wander_timer -= delta
	if wander_timer <= 0:
		# exit wander

		current_state = state.IDLE
	#check for walls
	if self.is_on_wall():
		flipping_direction()
	velocity.x = direction * SPEED
	if direction  == -1:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	if is_on_floor():
		wander_hop()
	else:
		velocity.y += wander_gravity * delta


func handle_chase(delta):
	
	if player:
		chase_direction = (player.global_position - self.global_position).normalized()
	
	if self.is_on_wall():
		flipping_direction()
	#$AnimatedSprite2D.play("Bee_agro")
	if chase_direction.x <= 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	velocity.x = chase_direction.x * chase_speed
	if is_on_floor():
		attack_hop()
	else:
		velocity.y += attack_gravity * delta




func handle_hurt(_delta):

		if is_hurt:
			knockback(player.global_position)
			#play hurt anim
			bunny_health -=1
			is_hurt = false
			if knockback_dir.x >= 0:
				anim_sprite.flip_h = true
			else:
				anim_sprite.flip_h = false






func handle_death(_delta):
	#$AnimatedSprite2D.play("Bee_death")
	#await $AnimatedSprite2D.animation_finished
	#if $AnimatedSprite2D.animation_finished:
	spawn_health()
	self.queue_free()


#flip the bunny direction
func flipping_direction():
	direction *= -1
	if direction  == -1:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	

func wander_hop():
	velocity.y = wander_jpower

func attack_hop():
	velocity.y = attack_jpower

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
	flipping_direction()

func _on_player_detetcor_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		current_state = state.CHASE

func _on_player_detetcor_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		current_state = state.WANDER
		
func spawn_health():
	
	if health_drop == null:
		print("error")
		return
	#this might not work
	for i in randi_range(2,3):
		if amount_dropped > 2:
			return
		var new_drop = health_drop.instantiate()
		new_drop.global_position = spawn_point.global_position
		get_tree().current_scene.add_child(new_drop)
		amount_dropped += 1
		

func _on_hurt_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack_area"):
		player = area
		is_hurt = true
		current_state = state.HURT


func _on_hurt_detect_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_attack_area"):
		player = null


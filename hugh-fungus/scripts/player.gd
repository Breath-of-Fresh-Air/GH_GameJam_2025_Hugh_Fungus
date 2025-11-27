extends CharacterBody2D
#state machine logic rewrite
var player_hurt_processed = false
var enemy 
 
#normal movement
const SPEED = 130.0
const JUMP_VELOCITY = -310.0
# double jump
var can_djump
const DJUMP_VELOCITY = -280.0
#respawn stuff
var respawn_point
#attack stuff
var can_attack = true
var attack_anim_finished = false
# knockback vars
var knockback_power = 260.0
var knockback_duration = 0.3
var knockback_active = false
var knockback_timer = 0.0
#Persistent facing direction (fixes snap-back bug)
var facing_dir: int = 1  # 1=right, -1=left


@onready var attack_collider = $attack_area/CollisionShape2D
@onready var anim_sprite = $AnimatedSprite2D
@onready var current_state = state.IDLE

enum state{
	IDLE,
	RUN,
	JUMP,
	HURT,
	FALL,
	ATTACK,
	DJUMP,
	DEATH,
}

####################################################
func _ready():
	attack_collider.disabled = true
	respawn_point = self.global_position
	$spawn_set_timer.start()
	
func _physics_process(delta: float) -> void:
	print(current_state)
	if not is_on_floor():
		velocity += get_gravity() * delta	
		# if active time count down
	if knockback_active:
		knockback_timer -= delta
		#smooth horizontal decel
		if knockback_timer <= 0:
			knockback_active = false
			player_hurt_processed = false
			enemy = null
			if is_on_floor():
				current_state = state.IDLE
			else:
				current_state = state.FALL
		velocity += get_gravity() * delta
		move_and_slide()
		return
	
	match current_state:
		state.IDLE:
			handle_idle(delta)
		state.RUN:
			handle_run(delta)
		state.JUMP:
			handle_jump(delta)
		state.DJUMP:
			handle_djump(delta)
		state.FALL:
			handle_fall(delta)
		state.ATTACK:
			handle_attack(delta)
		state.HURT:
			handle_hurt(delta)
		state.DEATH:
			handle_death(delta)
	move_and_slide()


func handle_idle(delta):
	if not is_on_floor():
		current_state= state.FALL
		return
	handle_left_right_input()
	handle_jump_input()
	handle_attack_input()
	if Input.get_axis("left", "right") != 0:
		current_state = state.RUN
		
	
	anim_sprite.play("idle")




func handle_run(delta):
	handle_left_right_input()
	handle_jump_input()
	handle_attack_input()
	if velocity.x == 0:
		current_state = state.IDLE
	anim_sprite.play("running")




func handle_jump(delta):
	handle_left_right_input()
	handle_attack_input()
	handle_jump_input()

	if velocity.y > 0:
		current_state = state.FALL
	anim_sprite.play("jump")




func handle_djump(delta):
	handle_left_right_input()
	handle_attack_input()
	handle_jump_input()
	if velocity.y > 0:
		current_state = state.FALL
	anim_sprite.play("double_jump")




func handle_fall(delta):
	if is_on_floor():
		current_state = state.IDLE
		return
	anim_sprite.play("falling")
	handle_left_right_input()
	handle_jump_input()
	handle_attack_input()




func handle_attack(delta):

	
	attack_collider.disabled = false
	
	handle_left_right_input()
	handle_jump_input()	
	anim_sprite.play("double_jump")	




func handle_hurt(delta):
	
	if player_hurt_processed:
		return
	knockback(enemy.global_position)
	PlayerHealthGlobal.player_health -=1
	player_hurt_processed = true
	if  PlayerHealthGlobal.player_health <=0:
		current_state = state.DEATH
	#anim_sprite.play("hurt")
		
	

func handle_death(delta):
	velocity = Vector2.ZERO
	#play death anim
	#open death menu after anim


func handle_left_right_input():
	# Get the input direction and handle the movement
	var direction := Input.get_axis("left", "right")
	if direction:
		facing_dir = int(direction)  # Update facing ONLY on input (1 or -1)
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#flipping anims based on direction
	if facing_dir == -1:
		anim_sprite.flip_h = true
	else:
		anim_sprite.flip_h = false




func handle_jump_input():
	if Input.is_action_just_pressed("jump") and (is_on_floor() or can_djump):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			current_state = state.JUMP
		elif can_djump:
			velocity.y = DJUMP_VELOCITY
			current_state = state.DJUMP
			can_djump = false

	if is_on_floor():
		can_djump = true



func handle_attack_input():
	if Input.is_action_just_pressed("attack") and can_attack:
		current_state = state.ATTACK
		can_attack = false
		$attack_time_timer.start()
		$attack_cooldown_timer.start()

#KNOCKBACK BABY!!!
func knockback(knockback_source: Vector2):
	knockback_active = true

	var knockback_dir = (self.global_position - knockback_source).normalized()
	
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
	


#set respawn point
func respawn_to_point():
	self.global_position = respawn_point



#reset atack
func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true




#reset spawn point on timer time out 
func _on_spawn_set_timer_timeout() -> void:
	if is_on_floor():
		respawn_point = self.global_position
	return



#check for pickups
func _on_pickup_detector_area_entered(area: Node2D) -> void:
	if area.is_in_group("health_pack"):
		if PlayerHealthGlobal.player_health >= 5:
			PlayerHealthGlobal.player_health = 5
			return
		PlayerHealthGlobal.player_health +=1



#check for enemy 
func _on_damage_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hitbox1"):
		enemy = area
		current_state = state.HURT
	
func _on_damage_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy_hitbox1"):
		if knockback_active == false:
			enemy = null



##check for bee
func _on_damage_area_body_entered(body: Node2D) -> void:
	if  body.is_in_group("Bee_enemy"):
		enemy = body
		current_state = state.HURT
		
	elif body.is_in_group("bunny_enemy"):
		enemy = body
		current_state = state.HURT



func _on_damage_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Bee_enemy"):
		if knockback_active == false:
			enemy = null
	elif body.is_in_group("Bunny_enemy"):
		if knockback_active == false:
			enemy = null


func _on_attack_time_timer_timeout() -> void:
	attack_collider.disabled = true
	

	# return to correct state
	if is_on_floor():
		current_state = state.IDLE
	else:
		current_state = state.FALL

extends CharacterBody2D
@onready var anim_sprite = $AnimatedSprite2D
var player_hurt = false
var enemy 
#feel free to mess with these but i think i have them dialed
#knockback 
var knockback_power = 260.0
var knockback_duration = 0.3
var knockback_active = false
var knockback_timer = 0.0
#normal movement
const SPEED = 130.0
const JUMP_VELOCITY = -310.0
#jump check
var jumping = false
# double jump
var can_djump
const DJUMP_VELOCITY = -280.0
#respawn stuff
var respawn_point

#i am gonna make this much cleaner sooner than later -M
func _ready():
	respawn_point = self.global_position
	$spawn_set_timer.start()
 
func _physics_process(delta: float) -> void:	
	if  PlayerHealthGlobal.player_health <=0:
		handle_death()
	# check for hurt, and snail is not null, call knockback
	if player_hurt and enemy:
		#call knockback w/ enemy pos
		knockback(enemy.global_position)
		PlayerHealthGlobal.player_health -= 1
		player_hurt = false
		# if active time count down
	if knockback_active:
		knockback_timer -= delta
		# 
		if knockback_timer <= 0:
			knockback_active = false
		#gives us our arch
		velocity += get_gravity() * delta
		move_and_slide()
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		#handle double jump
		if can_djump and Input.is_action_just_pressed("jump"):
			velocity.y = DJUMP_VELOCITY
			can_djump = false
	#reset double jump
	if is_on_floor():
		jumping = false
		can_djump = true
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumping = true
		velocity.y = JUMP_VELOCITY
	
	
		
	# Get the input direction and handle the movement
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	
	# --- Animation logic ---

# Player moving and not jumping
	if velocity.length() > 0 and !jumping:
		anim_sprite.play("running")
		
# Player moving and jumping
	elif velocity.length() > 0 and jumping:
		anim_sprite.play("jump")
		
# Player stopped and not jumping 
	elif velocity.length() == 0 and !jumping:
		anim_sprite.play("idle")
		
# Player stopped and jumping 
	elif velocity.length() == 0 and jumping:
			anim_sprite.play("jump")
# Player double jumping
	elif !can_djump:
		anim_sprite.play("jump")
	#flipping anims based on direction
	if direction == -1:
		anim_sprite.flip_h = true
	else:
		anim_sprite.flip_h = false	
	move_and_slide()

#check for enemy 
func _on_damage_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hitbox1"):
		enemy = area
		player_hurt = true
	
func _on_damage_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy_hitbox1"):
		if knockback_active == false:
			enemy = null

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

#handle death
func handle_death():
	pass
#check for pickups
func _on_pickup_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("health_pack"):
		if PlayerHealthGlobal.player_health >= 5:
			PlayerHealthGlobal.player_health = 5
			return
		PlayerHealthGlobal.player_health +=1

#reset spawn point on timer time out 
func _on_spawn_set_timer_timeout() -> void:
	if is_on_floor():
		respawn_point = self.global_position
	return


func _on_damage_area_body_entered(body: Node2D) -> void:
	if  body.is_in_group("Bee_enemy"):
		enemy = body
		player_hurt = true



func _on_damage_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Bee_enemy"):
		if knockback_active == false:
			enemy = null

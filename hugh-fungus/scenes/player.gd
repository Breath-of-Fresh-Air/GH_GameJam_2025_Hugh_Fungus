extends CharacterBody2D
@onready var anim_sprite = $AnimatedSprite2D
var player_hurt = false
var snail 

#knockback vars
var knockback_power = 300.0
var knockback_duration = 0.4
var knockback_active = false
var knockback_timer = 0.0
const SPEED = 180.0
const JUMP_VELOCITY = -360.0




func _physics_process(delta: float) -> void:
	if player_hurt and snail:
		knockback(snail.global_position)
		player_hurt = false
	if knockback_active:
		knockback_timer -= delta
		if knockback_timer <= 0:
			knockback_active = false
		velocity += get_gravity() * delta
		move_and_slide()
		return
	# Add the gravity.
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#handle hurt
	
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	
	# --- Animation logic ---

	if velocity.length() > 0:
		# Player is moving
		anim_sprite.play("running")
	else:
		# Player stopped
		anim_sprite.play("idle")
	if direction == -1:
		anim_sprite.flip_h = true
	else:
		anim_sprite.flip_h = false	
	move_and_slide()


func _on_damage_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hitbox1"):
		snail = area
		player_hurt = true

func _on_damage_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy_hitbox1"):
		if knockback_active == false:
			snail = null

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
	
	knockback_timer = knockback_duration
	


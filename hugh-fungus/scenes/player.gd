extends CharacterBody2D
@onready var anim_sprite = $AnimatedSprite2D
var player_hurt = false
var snail 
var enemy_attacking = true

const SPEED = 180.0
const JUMP_VELOCITY = -360.0




func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#handle hurt
	if player_hurt == true:
		knockback(20.0,self.global_position.x,1)
		
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

func knockback(force: float,x_pos: float, up_force:float):
	#coming from left bounce to right

	if x_pos < snail.global_position.x:
		velocity = Vector2(force * 2, -force * up_force)
	else:
		velocity = Vector2(-force * 2, -force * up_force)
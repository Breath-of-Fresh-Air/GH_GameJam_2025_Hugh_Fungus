extends CharacterBody2D
@onready var anim_sprite = $AnimatedSprite2D
@onready var current_state = state.IDLE
var deer_health = 10
var player
var is_idle
var idle_timer = 0.0
var idle_duration = 2.0
var can_attack = false
var can_hurt = false
enum state {
	IDLE,
	ATTACK,
	HURT,
	DEATH,
	}

func _ready():
	pass

func _physics_process(delta: float) -> void:
	if deer_health <= 0:
			current_state = state.DEATH
	if is_idle:
		idle_timer -= delta
		if idle_timer <= 0 and can_attack:
			is_idle = false
			current_state = state.ATTACK
	if can_hurt == true:
		current_state = state.HURT
			
	
	
		
	
	match current_state:
		state.IDLE:
			handle_idle(delta)
		state.ATTACK:
			handle_attack(delta)
		state.HURT:
			handle_hurt(delta)
		state.DEATH:
			handle_death(delta)
	move_and_slide()




func handle_idle(delta):
	is_idle = true
	anim_sprite.play("idle")


func handle_attack(delta):
	if can_attack:
		idle_timer = idle_duration
		anim_sprite.play("attack")
		
		if anim_sprite.flip_h == true:
			$hitbox_1/CollisionShape2D.disabled = false
		if anim_sprite.flip_h == false:
			$hitbox_2/CollisionShape2D2.disabled = false
		await anim_sprite.animation_finished
		$hitbox_1/CollisionShape2D.disabled = true
		$hitbox_2/CollisionShape2D2.disabled = true
		current_state = state.IDLE

func handle_hurt(delta):
	
	var is_hurt =false
	if !is_hurt:
		deer_health -=1
		print("hurt",deer_health)
		is_hurt = true
	
func handle_death(delta):
	if deer_health <= 0:
		#pop up game end thingy
		pass

func _on_flip_time_timeout() -> void:
	if anim_sprite.flip_h == true:
		anim_sprite.flip_h = false
	else:
		anim_sprite.flip_h = true

func _on_attack_timer_cooldown_timeout() -> void:
		can_attack = true


func _on_hurt_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack_area"):
		player = area
		if is_idle == true:
			can_hurt = true



func _on_hurt_detect_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_attack_area"):
		player = null
		

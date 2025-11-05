extends CharacterBody2D

@export var speed := 155
@onready var anim_sprite := $AnimatedSprite2D

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
	anim_sprite.flip_h = velocity.x < 0


	

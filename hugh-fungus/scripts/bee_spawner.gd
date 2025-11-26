extends Node2D
@onready var anim_sprite = $AnimatedSprite2D
@export var bee_enemy: PackedScene
@onready var spawn_point = $spawn_point
var player
var spawning
var can_spawn
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not spawning:
		anim_sprite.play("beehive_normal")
	if not player == null:
		can_spawn = true

func _on_spawn_timer_timeout() -> void:
	if can_spawn:
		spawn_enemy()
		spawning = true
	return
func spawn_enemy():
	if bee_enemy == null:
		print("error")
		return
	anim_sprite.play("beehive_spawning")
	var new_bee = bee_enemy.instantiate()
	new_bee.global_position = spawn_point.global_position
	get_tree().current_scene.add_child(new_bee)
	await anim_sprite.animation_finished
	spawning = false

func _on_player_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		


func _on_player_detect_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null

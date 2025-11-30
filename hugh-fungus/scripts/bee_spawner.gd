extends Node2D
@onready var anim_sprite = $AnimatedSprite2D
@export var bee_enemy: PackedScene
@onready var spawn_timer = $spawn_timer
@onready var spawn_point = $spawn_point
var player
var atk_player
var spawning
var can_spawn
#var random_hNumber = randi_range(0,6)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not spawning:
		anim_sprite.play("beehive_normal")
	if not player == null:
		can_spawn = true
	if atk_player:
		handle_break()



func handle_break():
	#playe anim 
	#spawn a honeycomb maybe make it a 1 in 10 chance?
	self.queue_free()

func _on_spawn_timer_timeout() -> void:
	if can_spawn:
		spawn_enemy()
		spawning = true
	return
func spawn_enemy():
	if bee_enemy == null:
		print("error")
		return
	$spawning_sound.play()
	anim_sprite.play("beehive_spawning")
	var new_bee = bee_enemy.instantiate()
	new_bee.global_position = spawn_point.global_position
	get_tree().current_scene.add_child(new_bee)
	spawning = false

func _on_player_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		


func _on_player_detect_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null




func _on_attack_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack_area"):
		atk_player = area


func _on_attack_detect_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_attack_area"):
		atk_player = null

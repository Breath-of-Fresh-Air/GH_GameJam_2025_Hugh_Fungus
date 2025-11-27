extends Area2D

var ngravity = 900
var velocity = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta):
	pass
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		self.queue_free()

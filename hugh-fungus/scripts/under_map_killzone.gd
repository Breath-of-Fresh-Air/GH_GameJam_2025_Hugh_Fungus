extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	#check for player
	if body.is_in_group("Player"):
		#determine player health
		if PlayerHealthGlobal.player_health >= 1:
			#-1 playerhealth 
			PlayerHealthGlobal.player_health -=1
			#call player respawn function
			body.respawn_to_point()
		elif PlayerHealthGlobal.player_health <= 0:
			#call player death function
			pass
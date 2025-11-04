extends Area2D

#declare traits 
var xp = 0 #mutable, experience = value of the "type" of diamond we make out of this
				   #green = 5, blue = 50, red = 500
var radius = 500 #radius for player to magnet gems in 
var speed = 250


#replicable physics - all diamonds will act this way 
#reference player, target it, pull self to player -> capsule collision -> add xp

var player_ref: Node = null

func _ready():
	player_ref = get_tree().get_nodes_in_group("Player")[0]
	
 #how the gems pull themselves to the player
func _physics_process(_delta):
	if player_ref and global_position.distance_to(player_ref.global_position) < radius:
		var dir = (player_ref.global_position - global_position).normalized()
		global_position += dir * speed * _delta

#thats all we need, the player will add xp to itself once obtaining the diamonds 
	

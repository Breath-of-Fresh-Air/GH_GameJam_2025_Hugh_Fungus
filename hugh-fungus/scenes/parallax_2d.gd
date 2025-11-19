extends Parallax2D

var player: Node2D

func _ready():
	player = get_parent().get_node("Player")

func _process(delta):
	if player:
		scroll_offset = -player.global_position

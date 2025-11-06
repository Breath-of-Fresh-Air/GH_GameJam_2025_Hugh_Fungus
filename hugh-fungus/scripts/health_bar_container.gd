extends HBoxContainer

@onready var health_bar_5 = $health_bar_5
@onready var health_bar_4 = $health_bar_4
@onready var health_bar_3 = $health_bar_3
@onready var health_bar_2 = $health_bar_2
@onready var health_bar_1 = $health_bar_1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlayerHealthGlobal.player_health >=5:
		health_bar_5.visible = true
	elif PlayerHealthGlobal.player_health == 4:
		health_bar_5.visible = false
		health_bar_4.visible = true
	elif PlayerHealthGlobal.player_health == 3:
		health_bar_4.visible =false
		health_bar_3.visible = true
	elif PlayerHealthGlobal.player_health == 2:
		health_bar_3.visible = false
		health_bar_2.visible = true
	elif PlayerHealthGlobal.player_health == 1:
		health_bar_2.visible = false
		health_bar_1.visible = true
	elif PlayerHealthGlobal.player_health == 0:
		health_bar_1.visible = false
extends Node
@onready var items_collected = 0
@onready var honey_comb = 0
@onready var empty_jar = 0
var honey_jar_collected = false
var honey_taget_pos
var honey_jar_placed
var bear_arrived
var bear_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if honey_comb >= 1 and empty_jar >= 1:
		honey_jar_collected = true

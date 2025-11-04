extends CharacterBody2D

@export var speed = 250



#start of Js work

#players current xp
var current_xp = 0
# players total xp | used for timed events, etc
var total_xp = 0
var current_level = 1

func add_experience(value):
	var new_xp = current_xp + value
	
	var cost_of_next = cost_of_next_lvl(current_level)
#while the player has more xp than the cost of the next level, do some math
	while new_xp >= cost_of_next:
		new_xp -= cost_of_next
		level_up()
		cost_of_next = cost_of_next_lvl(current_level)

	current_xp = new_xp
	
#cost of next lvl based on current lvl, n
func cost_of_next_lvl(n): 
	var base = 50
	var r = 3 
	
	# levels 1-25
	if n in range(1, 26):   # 1 to 25
		return base + r 
	elif n in range(26, 51):  # 26 to 50
		return base + r**2
	elif n in range(51, 76):  # 51 to 75
		return base + r**3
	elif n in range(76, 101):  # 76 to 100
		return base + r**4
	else:
		# optional: scale beyond level 100 if player keeps leveling
		return base + r**5

	

func level_up(): 
	current_level += 1


#end of Js work

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()

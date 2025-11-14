extends Node2D

#player_amplitude and frequency controls
@export var player_amplitude: float = 40.0 #height of the wave
@export var player_frequency: float = 0.5   #number of cycles across screen width
@export var phase: float = 0.0       #phase shift left/right
@export var player_speed: float = 2.4 #directly influences phase shift with a relationship to delta (1/60)

func _process(delta):
#animate the wave by increasing phase
	phase += player_speed * delta
	queue_redraw()  #request to redraw the wave every frame
#draws the players wave
func _draw():
	var points_along_sinwave = []
	var width = get_viewport().get_visible_rect().size.x


	
	for x in range(width):
		var y = player_amplitude * sin((x / width) * player_frequency * TAU + phase)
		points_along_sinwave.append(Vector2(x, y))
	
	#center the wave vertically
	for i in range(points_along_sinwave.size() - 1):
		draw_line(points_along_sinwave[i] + Vector2(0, get_viewport_rect().size.y / 2),
				  points_along_sinwave[i + 1] + Vector2(0, get_viewport_rect().size.y / 2),
				  Color(0.998, 0.696, 0.756, 1.0), 6, true)

func set_player_wave(A:= player_amplitude,F:= player_frequency,S:= player_speed):
	player_amplitude = A
	player_frequency = F
	player_speed = S

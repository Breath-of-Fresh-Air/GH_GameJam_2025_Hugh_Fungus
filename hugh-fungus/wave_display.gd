extends Node2D

#Amplitude and wavelength controls
@export var amplitude: float = 40.0  #height of the wave
@export var frequency: float = 5.0   #number of cycles across screen width
@export var phase: float = 0.0       #phase shift left/right
@export var speed: float = 3.5 #directly influences phase shift with a relationship to delta (1/60)

func _process(delta):
#animate the wave by increasing phase
	phase += speed * delta
	queue_redraw()  #request to redraw the wave every frame

func _draw():
	var points_along_sinwave = []
	var width = get_viewport().get_visible_rect().size.x
	print("Viewport height: ", get_viewport_rect().size.y)


	
	for x in range(width):
		var y = amplitude * sin((x / width) * frequency * TAU + phase)
		points_along_sinwave.append(Vector2(x, y))
	
	#center the wave vertically
	for i in range(points_along_sinwave.size() - 1):
		draw_line(points_along_sinwave[i] + Vector2(0, get_viewport_rect().size.y / 2),
				  points_along_sinwave[i + 1] + Vector2(0, get_viewport_rect().size.y / 2),
				  Color(0.967, 0.764, 0.0, 1.0), 6)

func set_target_wave(A:= amplitude,F:= frequency,P:= phase,S:= speed):
	amplitude = A
	frequency = F
	phase = P
	speed = S

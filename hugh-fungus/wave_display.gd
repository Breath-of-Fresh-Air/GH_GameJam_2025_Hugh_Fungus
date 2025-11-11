extends Node2D

# Amplitude and wavelength controls
@export var amplitude: float = 40.0  #height of the wave
@export var frequency: float = 2.0   #number of cycles across screen width
@export var phase: float = 0.0       #phase shift left/right
var speed = 1.0

func _process(delta):
	# animate the wave by increasing phase
	phase += speed * delta
	queue_redraw()  # request to redraw the wave every frame

func _draw():
	var points = []
	var width = get_viewport_rect().size.x
	
	for x in range(width):
		var y = amplitude * sin((x / width) * frequency * TAU + phase)
		points.append(Vector2(x, y))
	
	# center the wave vertically
	for i in range(points.size() - 1):
		draw_line(points[i] + Vector2(0, get_viewport_rect().size.y / 2),
				  points[i + 1] + Vector2(0, get_viewport_rect().size.y / 2),
				  Color(0, 1, 1), 2)

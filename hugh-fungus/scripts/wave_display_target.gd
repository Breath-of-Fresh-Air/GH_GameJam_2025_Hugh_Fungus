extends Node2D

#target_amplitude and frequency controls
@export var target_amplitude: float = 40.0  #height of the wave
@export var target_frequency: float = 5.0   #number of cycles across screen width
@export var phase: float = 0.0       #phase shift left/right
@export var target_speed: float = 3.5 #directly influences phase shift with a relationship to delta (1/60)

func _process(delta):
#animate the wave by increasing phase
	phase += target_speed * delta
	queue_redraw()  #request to redraw the wave every frame

func _draw():
	var points_along_sinwave = []
	var width = get_viewport().get_visible_rect().size.x


	
	for x in range(width):
		var y = target_amplitude * sin((x / width) * target_frequency * TAU + phase)
		points_along_sinwave.append(Vector2(x, y))
	
	#center the wave vertically
	for i in range(points_along_sinwave.size() - 1):
		draw_line(points_along_sinwave[i] + Vector2(0, get_viewport_rect().size.y / 2),
				  points_along_sinwave[i + 1] + Vector2(0, get_viewport_rect().size.y / 2),
				  Color(0.967, 0.764, 0.0, 1.0), 6, true)

func set_random_target_wave(A:= target_amplitude,F:= target_frequency,P:= phase,S:= target_speed):
	target_amplitude = randf_range(40.0, 175.0)
	target_frequency = randf_range(3.5, 9.5)
	target_speed = randf_range(1.9,9.9)
	print("\nATTENTION* This script is called wave_display_target.gd\n\nTarget Wave Attributes After Changes:\nAmplitude:",target_amplitude,"\nFrequency:",
	target_frequency,"\nSpeed:",target_speed,"\n__________________________________________")
	

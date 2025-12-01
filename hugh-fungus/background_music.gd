extends AudioStreamPlayer
#preload Hugh Fungus OST  - VooDooVince c 
var CastleOfIllusion = preload("res://audio/OST/Castle_of_Illusion.mp3")
var ElderForest = preload("res://audio/OST/Elder_Forest.mp3")
var Objection = preload("res://audio/OST/Objection!.mp3")
var MetroCityZone = preload("res://audio/OST/Sonic 2 - Metro City Zone.mp3")
var theyreComing = preload("res://audio/OST/They're coming!.mp3")
var VincetheUnwise = preload("res://audio/OST/VincentTheUnwise.mp3")
var scummBar = preload("res://audio/OST/The Scumm Bar.mp3")
var rats = preload("res://audio/OST/rats.mp3")

#split into distinct areas
var ground_playlist = [Objection, rats]
var treetio_playlist = [theyreComing, MetroCityZone, ElderForest]
var firstGroundPlayed #check if the first song has been played yet before random

#we never want to play the same track twice in a row. 
var last_track = null


var current_area_playlist = null  # keeps track of the current area

func _ready():
	# Player spawns in ground level first
	current_area_playlist = ground_playlist
	play_area_track(current_area_playlist)

func play_area_track(area_playlist):
	current_area_playlist = area_playlist  # update current area
	var next_track

	# Ground area: first play is fixed
	if area_playlist == ground_playlist and !firstGroundPlayed:
		next_track = Objection
		firstGroundPlayed = true
	else:
		next_track = area_playlist[randi() % area_playlist.size()]
		while next_track == last_track and area_playlist.size() > 1:
			next_track = area_playlist[randi() % area_playlist.size()]

	last_track = next_track
	stream = next_track
	play()

func _on_track_finished():
	# Play another track from the current area
	if current_area_playlist:
		play_area_track(current_area_playlist)

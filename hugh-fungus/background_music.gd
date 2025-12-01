extends AudioStreamPlayer
#preload Hugh Fungus OST  - VooDooVince c 
var CastleOfIllusion = preload("res://audio/OST/Castle_of_Illusion.mp3")
var ElderForest = preload("res://audio/OST/Elder_Forest.mp3")
var Objection = preload("res://audio/OST/Objection!.mp3")
var MetroCityZone = preload("res://audio/OST/Sonic 2 - Metro City Zone.mp3")
var theyreComing = preload("res://audio/OST/They're coming!.mp3")
var VincetheUnwise = preload("res://audio/OST/VincentTheUnwise.mp3")
var scummBar = preload("res://audio/OST/The Scumm Bar.mp3")



#we never want to play the same track twice in a row. 
var last_track = null


func _ready():
	#play the loaded streamable content
	play()
	stop()

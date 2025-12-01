extends Node

# Global flags
var firstBearEncounter = false
#honey
var collectedJar = false
var collectedHoney = false
#mycelium
var mycelium1 = false
var mycelium2 = false
var mycelium3 = false
#level check
var is_level_1 = true
var is_level_2 = false
#helper functions
func reset():
	firstBearEncounter = false
	collectedHoney = false
	mycelium1 = false
	mycelium2 = false
	mycelium3 = false
	collectedJar = false
	collectedHoney = false

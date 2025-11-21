extends Node2D
#minigameloop vars
var amp_found = false
var freq_found = false
var speed_found = false
var puzzle_solved = false
var display_count = 0 #used to display text on a particular frame, must be reset @60


#modular format would be to split up attribute checks and just call those 3 methods for target wave. 
#...............................................................................
#Amplitude check
func same_amp():
	if !puzzle_solved:
		if abs($TargetWaveDisplay.target_amplitude - $PlayerWaveDisplay.player_amplitude)<= 0.5:
			amp_found = true
			print("AMPLITUDE MATCHED")
		else:
			amp_found = false

#Frequency
func same_freq():
	if abs($TargetWaveDisplay.target_frequency - $PlayerWaveDisplay.player_frequency)<= 0.01:
		freq_found = true
		print("FREQ")
	else:
		freq_found = false
	
#Speed
func same_speed():
	if abs($TargetWaveDisplay.target_speed - $PlayerWaveDisplay.player_speed)<= 0.02:
		speed_found = true  
		print("speed")
	else:
		speed_found = false
	
	
#do the waves attributes closely match?
func check_if_found_target_wave():
	if !puzzle_solved:
		same_amp()
		same_freq()
		same_speed()
		if amp_found and freq_found and speed_found:
			puzzle_solved = true
		else:
			puzzle_solved = false
		
		
		
	# basically, check the abs value of the difference is less or equal to some amount to consider
	# "found"


func _ready():
	#start EM-minigame
	$startMiniTimer.start()
	#hide waves briefely
	$PlayerWaveDisplay.visible = false
	$TargetWaveDisplay.visible = false

	
	print("\nATTENTION* This script is called EM_Waves_Minigame.gd\n\nTarget Wave Attributes:\nAmplitude:",$TargetWaveDisplay.target_amplitude,"\nFrequency:",
	$TargetWaveDisplay.target_frequency,"\nSpeed:",$TargetWaveDisplay.target_speed,"\n__________________________________________")
	
	print("Player Wave Attributes:\nAmplitude:",$PlayerWaveDisplay.player_amplitude,"\nfrequency:",
	$PlayerWaveDisplay.player_frequency,"\nSpeed:",$PlayerWaveDisplay.player_speed,"\n__________________________________________")



	print("now calling the internal set function from target_display_target.tscn\n\nPress Space bar to set")
	$TargetWaveDisplay.set_random_target_wave()
	
#runs 60x per second
func _physics_process(delta: float) -> void:
#display player/target real time attributes for testing sake
	if display_count<=60:
		display_count += 1
	else:
		display_count = 0
		print("Amp\tPlayer:", $PlayerWaveDisplay.player_amplitude,"\tFrequency:",$PlayerWaveDisplay.player_frequency,"\tSpeed:", $PlayerWaveDisplay.player_speed)
		print("Amp\tTarget:", $TargetWaveDisplay.target_amplitude,"\tFrequency:",$TargetWaveDisplay.target_frequency,"\tSpeed:", $TargetWaveDisplay.target_speed)

#check if the waves match!
	check_if_found_target_wave() #controls the state of puzzle_solved, and individual attributes (T/F)
	
#if its solved...
	if puzzle_solved:
		print("you win!")
		$TargetWaveDisplay.set_random_target_wave()
		puzzle_solved = false #reset to false, trips check_if_found_target_wave 
		

#manual switch for changing the target wave
	if Input.is_action_just_pressed("ui_accept"):
		$TargetWaveDisplay.set_random_target_wave()
	
		
		
#starttimer functions...........................................................
func timeOut_sinWaveTimer():
	turn_on_flash() #flash on
	$hugh.visible = false #makes hugh invisible after the timer ends
	$PlayerWaveDisplay.visible = true#waves come on screen overlayed on the skull backgrounds
	$TargetWaveDisplay.visible = true

func EM_Player_Controls():
	$PlayerWaveDisplay.set_player_wave(
		$amplitudeVSlider.value,
		$wavelengthHSlider.value,
		$speedVSlider.value)


#slider controls................................................................
func _on_amplitude_v_slider_value_changed(value: float) -> void:
	$PlayerWaveDisplay.player_amplitude = value


func _on_frequency_h_slider_value_changed(value: float) -> void:
	$PlayerWaveDisplay.player_frequency = value


func _on_speed_v_slider_value_changed(value: float) -> void:
	$PlayerWaveDisplay.player_speed = value


#flash timer/related methods....................................................
func _on_white_flash_timer_timeout() -> void:
	#we want the WhiteFlashRect to disappear, giving the illusion of a flashback or something
	$WhiteFlashRect.visible = false #turns off rectangle

func turn_on_flash():
	$WhiteFlashRect.visible = true #turns on rectangle
	$whiteFlashTimer.start()
	
	
	pass # Replace with function body.

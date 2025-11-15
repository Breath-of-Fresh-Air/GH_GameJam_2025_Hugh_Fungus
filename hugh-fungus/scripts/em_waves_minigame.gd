extends Node2D
#minigameloop vars
var amp_found = false
var freq_found = false
var speed_found = false
var puzzle_solved = false
var display_count = 0 #used to display text on a particular frame, must be reset @60


#call this function in physics process when ready to test mini game
func check_if_found_target_wave():
	puzzle_solved = false # reset for the check
	if !puzzle_solved:
		if abs($TargetWaveDisplay.target_amplitude - $PlayerWaveDisplay.player_amplitude)== 0.0:
			amp_found = true
			print("Amplitudes match!")
		if abs($TargetWaveDisplay.target_frequency - $PlayerWaveDisplay.player_frequency)==0.0:
			freq_found = true
			print("frequencies match!")
		if abs($TargetWaveDisplay.target_speed - $PlayerWaveDisplay.player_speed)==0.0:
			speed_found = true  
			print("speed matched!")
		if amp_found and freq_found and speed_found:
			puzzle_solved = true
			print("Puzzle solved!")
		
		
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
	
	
func _physics_process(delta: float) -> void:
	check_if_found_target_wave()
	if Input.is_action_just_pressed("ui_accept"):
		$TargetWaveDisplay.set_random_target_wave()
	
		
		
#timer functions
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


#slider controls
func _on_amplitude_v_slider_value_changed(value: float) -> void:
	$PlayerWaveDisplay.player_amplitude = value


func _on_frequency_h_slider_value_changed(value: float) -> void:
	$PlayerWaveDisplay.player_frequency = value


func _on_speed_v_slider_value_changed(value: float) -> void:
	$PlayerWaveDisplay.player_speed = value


#flash timer
func _on_white_flash_timer_timeout() -> void:
	#we want the WhiteFlashRect to disappear, giving the illusion of a flashback or something
	$WhiteFlashRect.visible = false #turns off rectangle

func turn_on_flash():
	$WhiteFlashRect.visible = true #turns on rectangle
	$whiteFlashTimer.start()
	
	
	pass # Replace with function body.

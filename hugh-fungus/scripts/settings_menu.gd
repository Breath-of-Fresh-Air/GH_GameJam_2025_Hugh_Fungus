extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	self.visible = false


func _on_h_scroll_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), value)


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"),value)


func _on_mastervol_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("master"),value)


func _on_music_button_toggled(toggled_on: bool) -> void:
	var bus = AudioServer.get_bus_index("music")
	AudioServer.set_bus_mute(bus, toggled_on)


func _on_sfx_button_toggled(toggled_on: bool) -> void:
	var bus = AudioServer.get_bus_index("sfx")
	AudioServer.set_bus_mute(bus, toggled_on)


func _on_master_button_toggled(toggled_on: bool) -> void:
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus, toggled_on)
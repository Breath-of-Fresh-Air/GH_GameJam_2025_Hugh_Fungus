extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$honeycomb/TextureRect.visible = false
	$mycelium/TextureRect.visible = false
	$mycelium2/TextureRect.visible = false
	$mycelium3/TextureRect.visible = false
	$jar/TextureRect.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if MyceliumTracker.items_collected >=3:
		$mycelium/TextureRect.visible = true
		$mycelium2/TextureRect.visible = true
		$mycelium3/TextureRect.visible = true
	if MyceliumTracker.items_collected ==2 :
		$mycelium/TextureRect.visible = true
		$mycelium2/TextureRect.visible = true
		$mycelium3/TextureRect.visible = false
	if MyceliumTracker.items_collected == 1 :
		$mycelium/TextureRect.visible = true
		$mycelium2/TextureRect.visible = false
		$mycelium3/TextureRect.visible = false
	if MyceliumTracker.items_collected <= 0  :
		$mycelium/TextureRect.visible = false
		$mycelium2/TextureRect.visible = false
		$mycelium3/TextureRect.visible = false
	if MyceliumTracker.honey_comb >= 1:
		$honeycomb/TextureRect.visible = true
	if MyceliumTracker.empty_jar >= 1:
		$jar/TextureRect.visible = true
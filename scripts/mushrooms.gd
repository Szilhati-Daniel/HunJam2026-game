extends CharacterBody3D

func _ready() -> void:
	var random = randf()
	if random > 0.5:
		$mushroom.visible = false
		$mushrooms.visible = true

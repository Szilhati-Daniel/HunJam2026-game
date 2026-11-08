extends Node3D

@export var flip_H: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (flip_H):
		$Sprite3D.flip_h = true
	else:
		$Sprite3D.flip_h = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

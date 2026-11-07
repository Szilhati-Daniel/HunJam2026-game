extends Node3D

@export
var player: CharacterBody3D
@export
var offset: Vector3

@onready var camera = $"Camera3D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target = player.position
	camera.look_at_from_position(target + offset * 4, target)

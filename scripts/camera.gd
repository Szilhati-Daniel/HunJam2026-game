extends Camera3D

@export
var player: CharacterBody3D
@export
var offset: Vector3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target = player.position
	self.position = target + offset
	
	look_at(target)

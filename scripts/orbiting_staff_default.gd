extends Node3D

@export var orbit_radius : float = 0.6
@export var orbit_speed : float = 1.5
@export var height_change_time_min : float = 0.5
@export var height_change_time_max : float = 2.0
@export var height_smoothing : float = 5.0
@export var base_height : float = 1.5

var current_height_offset : float = 0.0
var target_height : float = 0.0
var height_change_timer : float = 0.0
var angle : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	angle += orbit_speed * delta
	self.position = Vector3(
		cos(angle) * orbit_speed,
		base_height + current_height_offset,
		sin(angle) * orbit_speed * 0.75
	)
	

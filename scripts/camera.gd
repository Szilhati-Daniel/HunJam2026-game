extends Node3D

@export
var player: CharacterBody3D
@export
var center_offset: Vector3 = Vector3(0, 3, 0)
@export
var offset: Vector3

@export var have_bounds: bool = false

## minx, maxx, minz, maxz
@export var bounds: Vector4

@export
var smoothing_agility: float = 6.5

@export
var camera_focus_points: Array[Node3D] = []
@export
var focus_treshold: float = 5.0

var current_center: Vector3
var center_target: Vector3
var actual_center: Vector3

@onready var camera = $"Camera3D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !player:
		pass
	
	center_target = player.position + center_offset
	actual_center = center_target
	
	var min_dst = 1000.0
	
	for focus_point in camera_focus_points:
		if !focus_point:
			continue
		
		var projected_focus = Vector2(focus_point.global_position.x, focus_point.global_position.z)
		var projected_center = Vector2(center_target.x, center_target.z)
		var dst = projected_focus.distance_squared_to(projected_center)
		if dst < focus_treshold * focus_treshold && dst < min_dst:
			actual_center = focus_point.global_position
			min_dst = dst
	
	var diff = (actual_center - current_center)
	var factor = delta * smoothing_agility
	if factor >= 1:
		current_center = actual_center
	else:
		current_center += diff * factor
	
	if have_bounds:
		current_center.x = clamp(current_center.x, bounds.x, bounds.y)
		current_center.z = clamp(current_center.z, bounds.z, bounds.w)
	
	camera.look_at_from_position(current_center + offset * 4, current_center)
	

extends Node3D

@export var foliage_prefabs: Array[PackedScene] = []
@export var spawn_under: Node
@export var spawn_count: int = 500
@export var min_distance: float = 1.0

var spawned_positions: Array[Vector3] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_foliage()

func spawn_foliage():
	if foliage_prefabs.is_empty():
		return
	
	spawned_positions.clear()
	
	var spawner = get_parent_node_3d()
	var bounds1 = spawner.global_position - spawner.scale * 0.67
	var bounds2 = spawner.global_position + spawner.scale * 0.67
	
	var attempts = 0
	var max_attempts = spawn_count * 20
	
	while spawned_positions.size() < spawn_count and attempts < max_attempts:
		attempts += 1
		
		var random_position = Vector3(
			randf_range(bounds1.x, bounds2.x),
			0.0,
			randf_range(bounds1.z, bounds2.z)
		)
		var valid_position = true
		
		for existing_position in spawned_positions:
			if random_position.distance_squared_to(existing_position) < min_distance * min_distance:
				valid_position = false
				break
		
		if valid_position:
			spawned_positions.append(random_position)
			
			var index = randi_range(0, foliage_prefabs.size() - 1)
			var foliage = foliage_prefabs[index].instantiate()
			foliage.position = random_position
			
			spawn_under.add_child(foliage)

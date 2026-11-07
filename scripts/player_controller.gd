extends CharacterBody3D

@export_range(0.1, 5.0, 0.01)
var movement_speed = 2.0
var health = 100.0
var last_direction = Vector3(0,0,1) # so that it starts out facing camera

@export
var target_scenes: Dictionary[Node3D, PackedScene]

@onready var face_towards: Sprite3D = $Sprites/Facing_Towards
@onready var face_away: Sprite3D = $Sprites/Facing_Away
@onready var face_left: Sprite3D = $Sprites/Facing_Left
@onready var face_right: Sprite3D = $Sprites/Facing_Right

@onready var damage: int = 25 # TODO

@onready var staff : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("init")
	staff = get_node_or_null("Staff") as Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector3()
	
	if Input.is_key_pressed(KEY_A):
		velocity.x -= 1.0
	if Input.is_key_pressed(KEY_D):
		velocity.x += 1.0
	if Input.is_key_pressed(KEY_W):
		velocity.z -= 1.0
	if Input.is_key_pressed(KEY_S):
		velocity.z += 1.0
		
	if Input.is_key_pressed(KEY_SPACE):
		staff.boink(last_direction)
		
	
	var delta_pos_x = Vector3(velocity.normalized().x, 0, 0) * movement_speed * delta
	var delta_pos_z = Vector3(0, 0, velocity.normalized().z) * movement_speed * delta
	
	change_sprite(velocity)
	
	move_and_collide(delta_pos_x)
	move_and_collide(delta_pos_z)

func change_sprite(direction : Vector3) -> void:
	if direction != Vector3.ZERO:
		last_direction = direction
		
	face_towards.visible = false
	face_away.visible = false
	face_left.visible = false
	face_right.visible = false
	
	if abs(last_direction.x) > 0:
		if last_direction.x > 0:
			face_right.visible = true
		else:
			face_left.visible = true
	else:
		if last_direction.z > 0:
			face_towards.visible = true
		else:
			face_away.visible = true	

func take_damage(damage : float) -> void:
	print("Oh no im dying :(")
	health -= damage
	print("\t current health: ", health)
	if health <= 0:
		death()
		
func get_boinked():
	$AnimationPlayer.plan("boink")
	take_damage(damage)

func death() -> void:
	#TODO kill, i mean implement
	return

func _on_area_3d_area_entered(area: Area3D) -> void:
	if not area.is_in_group("trigger"):
		pass
	
	print("trigger")
	var trigger = area.get_parent_node_3d()
	print(trigger)
	print(target_scenes)
	
	if target_scenes.has(trigger):
		print("found it")
		var new_scene = target_scenes.get(trigger).instantiate()
		print(new_scene)
		await get_tree().change_scene_to_node(new_scene)
	

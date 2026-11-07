extends CharacterBody3D

@export_range(0.1, 5.0, 0.01)
var movement_speed = 2.0
var health = 100.0
@onready
var character = $"Area3D"

@onready var face_towards: Sprite3D = get_node("Facing_Towards")
@onready var face_away: Sprite3D = get_node("Facing_Away")
@onready var face_left: Sprite3D = get_node("Facing_Left")
@onready var face_right: Sprite3D = get_node("Facing_Right")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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
	
	var delta_pos = velocity.normalized() * movement_speed * delta
	
	change_sprite(velocity)
	
	move_and_collide(delta_pos)
	#self.position += delta_pos

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("scene_geom"):
		print("collision")

func change_sprite(direction : Vector3) -> void:
	face_towards.visible = false
	face_away.visible = false
	face_left.visible = false
	face_right.visible = false
	
	if direction == Vector3(0,0,0):
		face_towards.visible = true
	else:
		if abs(direction.x):
			if direction.x > 0:
				face_right.visible = true
			else:
				face_left.visible = true
		else:
			if direction.z > 0:
				face_towards.visible = true
			else:
				face_away.visible = true	

func take_damage(damage : float) -> void:
	print("Oh no im dying :(")
	health -= damage
	print("\t current health: ", health)
	if health <= 0:
		death()
	else:
		return
func death() -> void:
	#TODO kill, i mean implement
	return

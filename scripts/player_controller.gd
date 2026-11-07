extends CharacterBody3D

@export_range(0.1, 5.0, 0.01)
var movement_speed = 2.0
var health = 100.0
@onready
var character = $"Area3D"

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
	move_and_collide(delta_pos)

func take_damage(damage : float) -> void:
	health -= damage
	if health <= 0:
		death()

func death() -> void:
	#TODO kill, i mean implement
	return

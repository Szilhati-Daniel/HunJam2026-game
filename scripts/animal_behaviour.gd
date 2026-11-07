extends CharacterBody3D

enum Behaviour {
	COWARDLY,
	AGGRESSIVE
}

@export var behaviour : Behaviour = Behaviour.AGGRESSIVE

@export var reaction_distance : float = 6.0
@export var attack_distance : float = 1.5
@export var movement_speed : float = 1.0
@export var idle_movement_speed : float = 2.0
@export var damage : float = 10.0
@export var attack_cooldown : float = 1.0
@export var health : float = 100.0
@export var idle_min_time : float = 1.0
@export var idle_max_time : float = 3.0
@export var idle_wait_min : float = 1.0
@export var idle_wait_max : float = 4.0

var idle_timer : float = 0.0
var is_idle_waiting : bool = true

var idle_direction : Vector3 = Vector3.ZERO
var last_direction = Vector3(0,0,0) # so its facing down when it spawns

var player : Node3D
var can_attack : bool = true

@onready var face_towards: Sprite3D = $"Facing_Towards"
@onready var face_away: Sprite3D = $"Facing_Away"
@onready var face_left: Sprite3D = $"Facing_Left"
@onready var face_right: Sprite3D = $"Facing_Right"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Animal path: ", get_path())
	print("Children: ", get_children())
	find_player()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var distance = self.global_position.distance_to(
		player.global_position
	)
	if distance > reaction_distance:
		idle_movement(delta)
		velocity = velocity.normalized() * idle_movement_speed

	else:
		match behaviour:
			Behaviour.COWARDLY:
				cowardly()
			Behaviour.AGGRESSIVE:
				aggressive(distance)
		velocity = velocity.normalized() * movement_speed
	change_sprite(velocity)
	move_and_slide()

func find_player() -> void:
	var main = get_tree().current_scene
	player = main.get_node_or_null("Player") as Node3D
	print("Found player: ", player)
		
func aggressive(distance : float) -> void:
	if distance <= attack_distance:
		stop_movement()
		attack_player()
	else:
		move_towards_player()

func change_sprite(direction : Vector3) -> void:
	if direction != Vector3.ZERO:
		last_direction = direction
		
	face_towards.visible = false
	face_away.visible = false
	face_left.visible = false
	face_right.visible = false
	
	var movement_angle = Vector2(last_direction.x, last_direction.z).angle()
	var movement_angle_degrees = rad_to_deg(movement_angle)
	
	if movement_angle_degrees >= -45 && movement_angle_degrees < 45:
		face_right.visible = true

	elif movement_angle_degrees >= 45 && movement_angle_degrees < 135:
		face_towards.visible = true
	elif movement_angle_degrees >= 135 || movement_angle_degrees < -135:
		face_left.visible = true
	else:
		face_away.visible = true

func cowardly() -> void:
	var direction = (
		self.global_position - player.global_position
	)
	
	self.velocity.x = direction.x
	self.velocity.z = direction.z

func move_towards_player() -> void:
	var direction = (
		player.global_position - self.global_position
	)
	
	self.velocity.x = direction.x
	self.velocity.z = direction.z

func stop_movement() -> void:
	self.velocity.x = 0.0
	self.velocity.z = 0.0

func idle_movement(delta : float) -> void:
	idle_timer -= delta
	if idle_timer <= 0:
		if is_idle_waiting:
			var angle = randf_range(0.0, TAU)
			idle_direction = Vector3(
				cos(angle),
				0,
				sin(angle)
			)
			is_idle_waiting = false
			idle_timer = randf_range(idle_min_time, idle_max_time)
		else:
			idle_direction = Vector3.ZERO
			is_idle_waiting = true
			idle_timer = randf_range(idle_wait_min, idle_wait_max)

	self.velocity.x = idle_direction.x * idle_movement_speed
	self.velocity.z = idle_direction.z * idle_movement_speed
	
func attack_player() -> void:
	if not can_attack:
		return
	can_attack = false
	player.take_damage(damage)
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func damaged_by_player(damage : float) -> void:
	health -= damage
	if health > 0:
		return
	else:
		death()

func death() -> void:
	#TODO: idk exactly but something needs to be done
	queue_free()
	return

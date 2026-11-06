extends Node

enum Behaviour {
	COWARDLY,
	AGGRESSIVE
}

@export var behaviour : Behaviour = Behaviour.AGGRESSIVE

@export var reaction_distance : float = 10.0
@export var attack_distance : float = 2.0
@export var movement_speed : float = 3.0
@export var damage : float = 10.0
@export var attack_cooldown : float = 1.0
@export var health : float = 100.0

var player : Node3D
var can_attack : bool = true

@onready var animal : CharacterBody3D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var distance = animal.global_position.distance_to(
		player.global_position
	)
	if distance > reaction_distance:
		stop_movement()
		return
	match behaviour:
		Behaviour.COWARDLY:
			cowardly()
		Behaviour.AGGRESSIVE:
			aggressive(distance)
			
			
func find_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	
	if players.size() > 0:
		player = players[0]
		
func aggressive(distance : float) -> void:
	if distance <= attack_distance:
		stop_movement()
		attack_player()
	else:
		move_towards_player()
		
func cowardly() -> void:
	var direction = (
		animal.global_position - player.global_position
	)
	
	animal.velocity.x = direction.x * movement_speed
	animal.velocity.z = direction.z * movement_speed
	
func move_towards_player() -> void:
	var direction = (
		player.global_position - animal.global_position
	)
	
	animal.velocity.x = direction.x * movement_speed
	animal.velocity.z = direction.z * movement_speed
	
func stop_movement() -> void:
	animal.velocity.x = 0.0
	animal.velocity.z = 0.0
	
func attack_player() -> void:
	if not can_attack:
		return
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
	return

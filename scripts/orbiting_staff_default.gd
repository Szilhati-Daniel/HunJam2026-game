extends Node3D

@export var orbit_radius : float = 0.6
@export var orbit_speed : float = 1.5
@export var base_height : float = 1.5
@export var attack_cooldown : float = 0
@export var damage : float = 0

var angle : float = 0.0
var target_rotation : float = 0.0
var can_attack : bool = true
var can_damage : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	angle += orbit_speed * delta
	self.position = Vector3(
		cos(angle) * orbit_speed,
		base_height,
		sin(angle) * orbit_speed * 0.75
	)

func boink(direction : Vector3) -> void:
	if not can_attack:
		return
	can_attack = false
	start_attack()
	if abs(direction.x) > 0:
		if direction.x > 0:
			$AnimationPlayer.play("boink-right")
		else:
			$AnimationPlayer.play("boink-left")
	else:
		if direction.z > 0:
			$AnimationPlayer.play("boink-towards")
		else:
			$AnimationPlayer.play("boink-away")

	await $AnimationPlayer.animation_finished
	end_attack()
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func start_attack() -> void:
	can_damage = true
	
func end_attack() -> void:
	can_damage = false

func _on_body_entered(body: Node3D) -> void:
	if ! can_damage:
		return
	else:
		if body.has_method("damaged_by_player"):
			end_attack()
			body.damaged_by_player(damage)
		if body.has_method("take_damage"):
			end_attack()
			body.take_damage(damage)
		if body.has_method("get_boinked"):
			body.get_boinked()

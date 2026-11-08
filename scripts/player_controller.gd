extends CharacterBody3D

@export_range(0.1, 100.0, 0.01)
var movement_speed = 5.0
var health = 100.0
var last_direction = Vector3(0,0,1) # so that it starts out facing camera

@export
var textbox: Control
@export
var interaction_prompt: Control

@onready var face_towards: Sprite3D = $Sprites/Facing_Towards
@onready var face_away: Sprite3D = $Sprites/Facing_Away
@onready var face_left: Sprite3D = $Sprites/Facing_Left
@onready var face_right: Sprite3D = $Sprites/Facing_Right

@onready var staff : Node3D

var nearby_interactable: Node3D = null
@onready var health_bar: Control = $HealthBar
@onready var camera: Camera3D = get_viewport().get_camera_3d()

@export var healthbar_height: float = 4.0

@onready var health_bar_progress: ProgressBar = $HealthBar/Panel/ProgressBar

@export var can_move: bool = true
var changing_scene = false

@onready var boink_sound: AudioStreamPlayer3D = $Sounds/Boink_Hit
@onready var move1_sound: AudioStreamPlayer3D = $Sounds/Move1
@onready var move2_sound: AudioStreamPlayer3D = $Sounds/Move2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("RESET")
	staff = get_node_or_null("Staff") as Node3D
	health = SceneDataManager.player_health
	move1_sound.volume_db = 9.0
	move2_sound.volume_db = 9.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health_bar_progress.value = health
	
	var velocity = Vector3()
	
	if nearby_interactable != null:
		var distance = global_position.distance_to(
			nearby_interactable.global_position
		)
		if distance > 8.0: #  I HAVE NO FUCKING IDEA WHY IT ONLY WORKS HERE BUT IDC ATP
			nearby_interactable = null
			interaction_prompt.hide()
			if textbox != null:
				textbox.visible = false
	
	if Input.is_key_pressed(KEY_A):
		velocity.x -= 1.0
		move2_sound.play()
	if Input.is_key_pressed(KEY_D):
		velocity.x += 1.0
		move2_sound.play()
	if Input.is_key_pressed(KEY_W):
		velocity.z -= 1.0
		move1_sound.play()
	if Input.is_key_pressed(KEY_S):
		velocity.z += 1.0
		move1_sound.play()
		
	if Input.is_key_pressed(KEY_SPACE):
		boink_sound.play()
		staff.boink(last_direction)
	
	var delta_pos_x = Vector3(velocity.normalized().x, 0, 0) * movement_speed * delta
	var delta_pos_z = Vector3(0, 0, velocity.normalized().z) * movement_speed * delta
	
	if can_move:
		change_sprite(velocity)

		move_and_collide(delta_pos_x)
		move_and_collide(delta_pos_z)
		#update_healthbar_position()

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
	#print("Oh no im dying :(")
	$AnimationPlayer.play("get_hit")
	health -= damage
	health_bar_progress.value = health
	#print("\t current health: ", health)
	if health <= 0:
		death()
		
func get_boinked():
	$AnimationPlayer.play("boink")
	
"""func update_healthbar_position() -> void:
	var head_position = global_position + Vector3.UP * healthbar_height

	if camera.is_position_behind(head_position):
		health_bar.hide()
		return

	health_bar.show()

	var screen_position = camera.unproject_position(head_position)

	health_bar.global_position = Vector2(
		screen_position.x - 120,
		screen_position.y - 12.5
	)"""

func death() -> void:
	#TODO kill, i mean implement
	return

func trigger_pause():
	HitStopManager.get_hit(0.25)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if changing_scene:
		return
	if area.is_in_group("interactable"):
		nearby_interactable = area.get_parent_node_3d()
		interaction_prompt.show()
	elif area.is_in_group("trigger"):
		changing_scene = true
		var scene_name = get_tree().current_scene.name
		
		var trigger_name = area.get_parent_node_3d().name
		var new_scene = SceneLoader.load_scene(scene_name, trigger_name)
		
		print(health)
		SceneDataManager.player_health = health
		
		if scene_name != "altar_scene":
			new_scene.load_from_level = scene_name
		
		SceneLoader.change_scene.call_deferred(new_scene)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_E:
			if nearby_interactable == null:
				return
			if textbox != null:
				if not textbox.visible:
					nearby_interactable.interact()
				else:
					textbox.advance_dialogue()
			else:
				nearby_interactable.interact()

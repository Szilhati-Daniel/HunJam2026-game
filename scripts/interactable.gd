extends Area3D

@export var interactable_node: Node
@export var radius: float = 1

@export var prompt_target_node: Node3D
@export var prompt_text: String = "interact"

@onready var camera: Camera3D = get_viewport().get_camera_3d()

func _ready():
	update_radius()
	
	hide_prompt()
	$CanvasLayer/prompt/Label.text = prompt_text
	update_prompt_position()

func _process(delta: float):
	update_prompt_position()

func update_radius():
	$CollisionShape3D.shape.radius = radius

func update_prompt_position():
	if camera == null:
		return
	
	if prompt_target_node == null:
		return
	
	var screen_position = camera.unproject_position(prompt_target_node.global_position)
	
	var prompt_size: Vector2 = $CanvasLayer/prompt.size
	var offset: Vector2 = Vector2(-prompt_size.x / 2, -prompt_size.y / 2)
	var final_position = screen_position + offset
	$CanvasLayer/prompt.global_position = final_position

func interact():
	interactable_node.interact()

func disable():
	$CollisionShape3D.disabled = true

func enable():
	$CollisionShape3D.disabled = false

func show_prompt():
	$CanvasLayer/prompt.visible = true

func hide_prompt():
	$CanvasLayer/prompt.visible = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		show_prompt()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		hide_prompt()

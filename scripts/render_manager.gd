extends Node3D

@export
var player: Node3D

@onready
var color_rect = $"CanvasLayer/ColorRect"
#@onready
 #var camera: Camera3D = get_viewport().get_camera_3d()

var can_start_flicker = true

func _ready():
	$AnimationPlayer.play("init_flicker")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_node(self)
	
	var shader = color_rect.material
	var screen_size = get_viewport().get_visible_rect().size
	shader.set_shader_parameter("screenSize", screen_size)
	
	if player:
		var light_source = get_node(str(player.get_path()) + "/Staff")
		
		var camera := get_viewport().get_camera_3d()
		var light_position = camera.unproject_position(light_source.global_position)
		
		shader.set_shader_parameter("lightCentre", light_position)

func _physics_process(delta):
	await start_periodic_flicker()

func start_periodic_flicker():
	if !can_start_flicker:
		return
	
	can_start_flicker = false
	var duration = randf_range(10, 30)
	await get_tree().create_timer(duration).timeout
	$AnimationPlayer.play("periodic_flicker")
	await $AnimationPlayer.animation_finished
	can_start_flicker = true
	
func process_node(node: Node3D):
	for sprite in node.get_children():
		if (sprite is Sprite3D):
			sprite.sorting_offset = sprite.global_position.z * 100.0
			#sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_OPAQUE_PREPASS
		if (sprite is Node3D):
			process_node(sprite)

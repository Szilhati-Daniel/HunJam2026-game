extends Node3D

@export
var light_source: Node3D

@onready
var color_rect = $"CanvasLayer/ColorRect"
@onready
var camera = $"Camera/Camera3D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_node(self)
	
	if light_source:
		var shader = color_rect.material
		var screen_size = get_viewport().size
		
		var light_position = camera.unproject_position(light_source.global_position)
		light_position /= Vector2(screen_size)
		light_position -= Vector2(0.5, 0.5)
		
		shader.set_shader_parameter("lightCentre", light_position)
		shader.set_shader_parameter("screenSize", screen_size)

func process_node(node: Node3D):
	for sprite in node.get_children():
		if (sprite is Sprite3D):
			sprite.sorting_offset = sprite.global_position.z * 100.0
			#sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_OPAQUE_PREPASS
		if (sprite is Node3D):
			process_node(sprite)

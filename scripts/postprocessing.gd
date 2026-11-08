extends CanvasLayer

@export
var shader: ShaderMaterial
@export
var invert_colours: bool = false

@onready
var rect = $"ColorRect"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rect.material = shader

func _process(delta: float) -> void:
	rect.material.set_shader_parameter("invert", invert_colours)
	

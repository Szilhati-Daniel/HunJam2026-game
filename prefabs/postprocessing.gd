extends CanvasLayer

@export
var shader: ShaderMaterial

@onready
var rect = $"ColorRect"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rect.material = shader

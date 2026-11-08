extends Node3D

var player_position_from_scene: Dictionary[String, Vector3] = {
	"default": Vector3(0, 0, 0),
	"level1": Vector3(-7.75, 0, -2.4),
	"level2": Vector3(1, 0, 8)
}

@export var load_from_level: String = "default"
@export var has_candle: bool = false
@export var has_rope: bool = false
@export var has_paint: bool = false

@onready var player = get_node("Player")

func _ready():
	var new_player_position = player_position_from_scene.get(load_from_level)
	player.position = new_player_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_node(self)

func process_node(node: Node3D):
	for sprite in node.get_children():
		if (sprite is Sprite3D):
			sprite.sorting_offset = sprite.global_position.z * 100.0
			#sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_OPAQUE_PREPASS
		if (sprite is Node3D):
			process_node(sprite)

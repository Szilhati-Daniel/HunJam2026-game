extends Node3D

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

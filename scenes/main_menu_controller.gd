extends Control

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
	var altar_scene = preload("res://scenes/altar_scene.tscn").instantiate()
	get_tree().change_scene_to_node(altar_scene)

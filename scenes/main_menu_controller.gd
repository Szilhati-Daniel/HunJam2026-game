extends Control

@onready var menu_sound: AudioStreamPlayer = $Sounds/Menu

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
	var altar_scene = preload("res://scenes/altar_scene.tscn").instantiate()
	get_tree().change_scene_to_node(altar_scene)
	
func _on_play_button_mouse_entered() -> void:
	menu_sound.volume_db = -8.0
	menu_sound.play()
	
func _on_exit_button_mouse_entered() -> void:
	menu_sound.volume_db = -8.0
	menu_sound.play()

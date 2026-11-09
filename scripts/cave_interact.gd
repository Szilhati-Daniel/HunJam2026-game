extends Node3D

@export
var textbox: Control
@export
var prompt: Control

@onready var animation_player = get_tree().current_scene.get_node("AnimationPlayer")

var player_nearby = false


func interact():
	if FlagManager.has_candle and FlagManager.has_rope and FlagManager.has_paint:
		prompt.hide()
		animation_player.play("end_cutscene")
	else:
		textbox.start_dialogue()

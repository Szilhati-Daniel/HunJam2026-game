extends Node3D

@onready var item = $item
@export var item_name: String


@onready var animation_player = get_tree().current_scene.get_node("AnimationPlayer")

		
func interact():
	$Interactable.hide_prompt()
	$Interactable.disable()
	animation_player.play("item_flicker")
	item.hide()
	update_data()

func update_data():
	if item_name == "candle":
		FlagManager.has_candle = true
	elif item_name == "rope":
		FlagManager.has_rope = true
	elif item_name == "paint":
		FlagManager.has_paint = true

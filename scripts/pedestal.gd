extends Node3D

@export var textbox: Control
@export var prompt: Control
@onready var item = $item
@export var item_name: String

var player_nearby = false

@onready var animation_player = get_tree().current_scene.get_node("AnimationPlayer")

func _ready():
	prompt.hide()

	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		prompt.show()


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		prompt.hide()
		
func interact():
	animation_player.play("item_flicker")
	item.hide()
	update_data()

func update_data():
	if item_name == "candle":
		SceneDataManager.has_candle = true
	elif item_name == "rope":
		SceneDataManager.has_rope = true
	elif item_name == "paint":
		SceneDataManager.has_paint = true

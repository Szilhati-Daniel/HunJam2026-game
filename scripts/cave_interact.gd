extends Node3D

@onready var textbox = get_node("/root/Node3D/CanvasLayer/TextBox")
@onready var prompt = get_node("/root/Node3D/CanvasLayer/InteractionPrompt")

var player_nearby = false

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
	textbox.start_dialogue()

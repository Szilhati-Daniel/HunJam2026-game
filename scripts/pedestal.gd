extends Node3D

@export var textbox: Control
@export var prompt: Control
@onready var item = $item

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
	item.hide()

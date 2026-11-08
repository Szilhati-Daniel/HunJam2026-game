extends Control

@onready var name_label = $Panel/MarginContainer/VBoxContainer/NameLabel
@onready var dialogue_text = $Panel/MarginContainer/VBoxContainer/DialogueText

var dialogue_lines = [
	["Altar", "Hey you're finally awake, sigma."],
	["Altar", "Things have been strange around here lately."],
	["Altar", "Decorate me :D"]
]

var current_line = 0

func _ready():
	visible = false

func start_dialogue():
	current_line = 0
	visible = true
	show_line()

func show_line():
	name_label.text = dialogue_lines[current_line][0]
	dialogue_text.text = dialogue_lines[current_line][1]

func advance_dialogue() -> void:
	if not visible:
		return
		
	current_line += 1

	if current_line >= dialogue_lines.size():
		visible = false
	else:
		show_line()
		
func change_dialogue_lines(new_lines: Array) -> void:
	dialogue_lines = new_lines
	current_line = 0
	show_line()

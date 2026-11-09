extends StaticBody3D

enum AltarState {
	NORMAL,
	CANDLE,
	ROPE,
	PAINT,
	FACE
}

@export var state: AltarState = AltarState.NORMAL

@onready var animation_player = get_tree().current_scene.get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_sprite()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_sprite()

func change_altar_state(new_state: AltarState):
	if state == new_state:
		return
	state = new_state
	update_sprite()
	
func update_sprite():
	$Sprites/normal.visible = false
	$Sprites/candle.visible = false
	$Sprites/rope.visible = false
	$Sprites/paint.visible = false
	$Sprites/face.visible = false
	
	match state:
		AltarState.NORMAL:
			$Sprites/normal.visible = true
		AltarState.CANDLE:
			$Sprites/candle.visible = true
		AltarState.ROPE:
			$Sprites/rope.visible = true
		AltarState.PAINT:
			$Sprites/paint.visible = true
		AltarState.FACE:
			$Sprites/face.visible = true

func interact():
	if FlagManager.has_candle and FlagManager.has_paint and FlagManager.has_rope:
		$Interactable.hide_prompt()
		$Interactable.disable()
		animation_player.play("end_cutscene")

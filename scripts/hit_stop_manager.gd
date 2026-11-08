extends Node


func get_hit(duration: float = 0.25):
	get_tree().paused = true
	
	await get_tree().create_timer(duration, true, false, true).timeout
	
	get_tree().paused = false

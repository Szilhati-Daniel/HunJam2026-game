extends Node

var has_candle: bool = false
var has_rope: bool = false
var has_paint: bool = false

var player_health: int = 100

func reset():
	has_candle = false
	has_rope = false
	has_paint = false
	player_health = 100

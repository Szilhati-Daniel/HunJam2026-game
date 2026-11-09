extends Node

var has_candle: bool = true
var has_rope: bool = true
var has_paint: bool = true

var player_health: int = 100

func reset():
	has_candle = false
	has_rope = false
	has_paint = false
	player_health = 100

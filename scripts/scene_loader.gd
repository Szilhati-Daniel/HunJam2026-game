extends Node

var target_scenes_altar: Dictionary[String, PackedScene] = {
	"toLevel1": preload("res://scenes/level1.tscn"),
	"toLevel2": preload("res://scenes/level2.tscn"),
	"toLevel3": preload("res://scenes/level3.tscn")
}

var target_scenes_level2: Dictionary[String, PackedScene] = {
	"toAltar": preload("res://scenes/altar_scene.tscn")
}

var target_scenes_level1: Dictionary[String, PackedScene] = {
	"toAltar": preload("res://scenes/altar_scene.tscn")
}

var target_dictionaries: Dictionary[String, Dictionary] = {
	"altar_scene": target_scenes_altar,
	"level1": target_scenes_level1,
	"level2": target_scenes_level2
}

func load_scene(scene_name: String, trigger_name: String):
	var target_dict = target_dictionaries.get(scene_name)
	var new_scene = target_dict.get(trigger_name).instantiate()
	await get_tree().change_scene_to_node(new_scene)

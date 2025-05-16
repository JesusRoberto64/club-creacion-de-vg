extends Node

var levels : Array = [
	"res://Escenas/Practica_3_Platformer/Niveles/Nivel01.tscn",
	"res://Escenas/Practica_3_Platformer/Niveles/Nivel02.tscn",
	"res://Escenas/Practica_3_Platformer/Niveles/Nivel03.tscn"
]

var cur_level : int = 0

func get_next_level() -> String:
	cur_level = (cur_level + 1) % levels.size()
	return levels[cur_level]

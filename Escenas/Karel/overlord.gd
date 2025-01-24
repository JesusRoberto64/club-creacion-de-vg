extends Node2D

@onready var karel = $Area/karel

var steps = []
var executing = false

func _ready() -> void:
	move()
	move()
	move()
	turn()
	move()

func move():
	steps.append("move")

func turn():
	steps.append("turn")
	pass

func execute_instructions():
	if executing: 
		print("Ejecutando")
		return
	
	executing = true
	for i in steps:
		if i == "move":
			await karel.move()
		elif i == "turn":
			await karel.turn()
	executing = false
	
	print("FINAL")

func restart():
	get_tree().reload_current_scene()

extends Node2D

@onready var karel = $Area/karel

var processExecute = false
var firstExecute = false
var execute = false
var steps = []

func _ready() -> void:
	set_move()
	set_move()
	set_turn()

func _process(_delta: float) -> void:
	if karel.is_free_space():
		move()
	else:
		turn()

func move():
	if !execute: return
	if !processExecute:
		processExecute = true
		await karel.move()
		processExecute = false

func turn():
	if !execute: return
	if !processExecute:
		processExecute = true
		await karel.turn()
		processExecute = false

func set_move():
	steps.append("move")

func set_turn():
	steps.append("turn")

func execute_instructions():
	#las intrucciones iniciales
	if firstExecute: 
		print("Ejecutado")
		return
	firstExecute = true
	
	if steps.size() > 1:
		for i in steps:
			if i == "move":
				await karel.move()
			elif i == "turn":
				await karel.turn()
	else :
		print("Sin órdenes iniciales")
	
	execute = true #despues de las instrucciones iniciales
	print("FINALIZA ORDENES INICIALES")

func restart():
	get_tree().reload_current_scene()

extends Node2D

@onready var karel = $Area/karel

# Called when the node enters the scene tree for the first time.
func _ready():
	execute_instructions()
	pass # Replace with function body.

func execute_instructions():
	#Ingresa las instrucciones para Karel
	#karel.move()
	await karel.turn()
	karel.move()
	
	
	print("Fin de programa")

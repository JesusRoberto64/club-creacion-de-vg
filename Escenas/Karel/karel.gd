extends Node2D
#Tamaño de celda 
const TITLE_SIZE : int = 32

#Direccion que mira Karel 
var Direction = ["UP", "RIGHT", "DOWN", "LEFT"]

var grid_position = Vector2i.ZERO
var direction = 1
var inventory : Array = []
var max_inventory : int = 5
var can_Move : bool = true

#signal for coroutines
signal moved

#Referencia de TileMapLayer
@export var tileMapLayer: TileMapLayer
@onready var spr : Sprite2D = $Sprite2D

func move():
	if not can_Move:
		return
	
	var next_position = grid_position
	var dir = Direction[direction]
	match dir:
		"UP":
			next_position.y -=1
		"RIGHT":
			next_position.x +=1
		"DOWN":
			next_position.y += 1
		"LEFT":
			next_position.x -= 1
	
	#Comprobar límites y coliciones
	
	#Mover visualmente
	move_animation(next_position)
 

func turn()-> Signal:
	direction = (direction + 1) % 4 #Puedes usar direction por que enum regresa un int
	var tween = create_tween()
	var new_rotation = spr.rotation_degrees + 90
	tween.tween_property(spr, "rotation_degrees", new_rotation, 0.5 )
	return tween.finished

#Funcion de animacion del movimiento
func move_animation(targer_pos: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", targer_pos * TITLE_SIZE, 0.5)
	moved.emit()

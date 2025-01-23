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
signal unblock

#Referencia de TileMapLayer
@export var tileMapLayer: TileMapLayer
@onready var spr : Sprite2D = $Sprite2D

func move()-> Signal:
	#print(tileMapLayer.get_cell_source_id(grid_position))
	
	var next_position = Vector2(grid_position.x, grid_position.y)
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
	
	if tileMapLayer.get_cell_source_id(Vector2i(next_position.x, next_position.y)) == 2:
		print("Karel NO PUEDE AVANZAR")
		return unblock
	
	if not can_Move:
		print("Karel NO PUEDE AVANZAR")
		return unblock
	
	
	#Mover visualmente
	var tween = create_tween()
	tween.tween_property(self, "position", next_position * TITLE_SIZE, 0.5)
	grid_position = Vector2i(next_position.x, next_position.y)
	print(grid_position)
	return tween.finished
 

func turn()-> Signal:
	direction = (direction + 1) % 4 #Puedes usar direction por que enum regresa un int
	var tween = create_tween()
	var new_rotation = spr.rotation_degrees + 90
	tween.tween_property(spr, "rotation_degrees", new_rotation, 0.5 )
	return tween.finished

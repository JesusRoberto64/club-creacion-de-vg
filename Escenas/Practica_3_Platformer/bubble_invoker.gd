extends Node2D

@onready var Bubble = preload("res://Escenas/Practica_3_Platformer/burbuja.tscn")
@onready var line : Line2D = $Line2D

var invoke_timer = 0.0
var invoke_timer_limit = 0.85

var level = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	invoke_timer += delta
	if invoke_timer > invoke_timer_limit:
		invoke_timer = 0.0
		var inst = Bubble.instantiate()
		inst.position.x = randf_range(0.0, line.get_point_position(0).x)
		add_child(inst)
		
	

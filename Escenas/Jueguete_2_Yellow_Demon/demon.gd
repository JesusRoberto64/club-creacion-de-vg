extends Node2D

var Parts : Array = []

var current_part = 0
var is_moving_part = false
var speed = 250
var direction = -1
var counter = 0

func _ready() -> void:
	Parts =  $Parts.get_children()
	$GlobalTimer.start()

func _physics_process(_delta: float) -> void:
	if is_moving_part:
		Parts[current_part].velocity.x = speed * direction
		Parts[current_part].move_and_slide()

func _on_global_timer_timeout() -> void:
	$GlobalTimer.stop()
	$PartsTimer.start()
	is_moving_part = true
	Parts[current_part].get_node("CollisionShape2D").one_way_collision = true

func _on_parts_timer_timeout() -> void:
	$PartsTimer.stop()
	$GlobalTimer.start()
	is_moving_part = false
	Parts[current_part].get_node("CollisionShape2D").one_way_collision = false
	#Explicar module
	current_part = (current_part + 1) % Parts.size()
	counter += 1
	if counter == Parts.size():
		direction *= -1
		counter = 0
		Parts.shuffle()

extends CharacterBody2D

var speed = 100
var movement : Vector2 = Vector2(1.0,1.0)

var radian = 0.0

func _physics_process(delta: float) -> void:
	
	radian += delta
	movement.x = sin(radian)
	movement.y = cos(radian)
	
	velocity = movement * speed
	move_and_slide()

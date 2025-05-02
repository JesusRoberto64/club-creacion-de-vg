extends AnimatableBody2D

var movement := Vector2.ZERO
var speed : float =1.6

var radius : float = 50
var radian : float = 0.0

@onready var pos = position

func _physics_process(delta: float) -> void:
	radian += speed * delta
	movement.x = sin(radian) * radius
	movement.y = cos(radian) * radius
	position = movement + pos
	pass

extends Area2D

#NIVEL 1
var speed = 35
var screen_size

#NIVEL 2
var direction : Vector2 = Vector2.ZERO
var lastDirection : Vector2 = Vector2.RIGHT
#Attack decay sustain realeace
@export var start_curve : Curve = null
@export var end_curve : Curve = null
var curveValue = 0.0
var accel = 0.0
var maxAccel = 130

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# NIVEL 1
#func _process(delta: float) -> void:
	#var velocity = Vector2.ZERO # The player's movement vector.
	#if Input.is_action_pressed("ui_right"):
		#velocity.x += 1
	#if Input.is_action_pressed("ui_left"):
		#velocity.x -= 1
	#if Input.is_action_pressed("ui_down"):
		#velocity.y += 1
	#if Input.is_action_pressed("ui_up"):
		#velocity.y -= 1
	#
	#if velocity.length() > 0:
		#velocity = velocity.normalized() * speed
	#
	#
	#
	#position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)

#NIVEL 2
#func _process(delta: float) -> void:
	#direction = Vector2.ZERO # The player's movement vector.
	#if Input.is_action_pressed("ui_right"):
		#direction.x += 1
	#if Input.is_action_pressed("ui_left"):
		#direction.x -= 1
	#if Input.is_action_pressed("ui_down"):
		#direction.y += 1
	#if Input.is_action_pressed("ui_up"):
		#direction.y -= 1
	##print(direction)
	#if direction.length() <= 0.0:
		#curveValue -= delta
		#curveValue = clamp(curveValue, end_curve.min_value, end_curve.max_value)
		## Invertir el valor para la curva end
		#var inverted_value = end_curve.max_value - (curveValue - end_curve.min_value)
		#accel = end_curve.sample(inverted_value)
	#else:
		#curveValue += delta
		#curveValue = clamp(curveValue, start_curve.min_value, start_curve.max_value)
		#accel = start_curve.sample(curveValue)
		#lastDirection = direction
	#
	#position += lastDirection * (accel*maxAccel) * delta
	#position = position.clamp(Vector2.ZERO, screen_size)

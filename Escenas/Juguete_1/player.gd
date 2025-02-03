extends CharacterBody2D

enum STATE {FLOOR, FLY, FALLING}
var maxJumpAir = 1
var jumpedAir = 0

var direction : Vector2 = Vector2.ZERO
var lastDirection : Vector2 = Vector2.RIGHT
var gravity = Vector2(0.0, 1.0) * 5.0
@export var maxVel = 100.0

@export var start_curve : Curve = null
@export var end_curve : Curve = null

#Attack decay sustain realeace
var accel = 0.0
var curveValue = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
	if Input.is_action_pressed("ui_down"):
		direction.y = 1 
	elif Input.is_action_pressed("ui_up"):
		direction.y = -1
	
	if direction.length() <= 0.0:
		curveValue += delta
		curveValue = clamp(curveValue, 0.0, 1.0)
		accel = end_curve.sample(curveValue)
	else:
		print(direction)
		curveValue += delta
		curveValue = clamp(curveValue, 0.0, 1.0)
		accel = start_curve.sample(curveValue)
		lastDirection = direction
		print(accel)
	

func _physics_process(delta: float) -> void:
	
	if (is_on_floor() and direction.y > 0) or (is_on_ceiling() and direction.y < 0):
		lastDirection.y = 0
	
	if (direction.x > 0 and get_wall_adjusment() < 0) or (direction.x < 0 and get_wall_adjusment() > 0):
		lastDirection.x = 0
	
	velocity = lastDirection.normalized() * (accel*maxVel) * delta
	move_and_slide()
	move_and_collide(velocity)

func get_wall_adjusment()-> float:
	return get_wall_normal().x if is_on_wall() else 0.0

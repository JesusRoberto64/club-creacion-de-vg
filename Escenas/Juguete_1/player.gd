extends CharacterBody2D

enum STATE { WALK, FLY, JUMPING, FALLING }
var state = STATE.FALLING

var maxJumpAir = 1
var jumpedAir = 0

var direction : Vector2 = Vector2.ZERO
var lastDirection : Vector2 = Vector2.RIGHT
var gravity = 8.6

var baseMaxVel
@export var maxVel = 100.0
@export_range(0, 100, 0.1) var sprint : float = 20

@export var start_curve : Curve = null
@export var end_curve : Curve = null

#Attack decay sustain realeace
var accel = 0.0
var curveValue = 0.0

func _ready() -> void:
	baseMaxVel = maxVel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	
	#este es el sitema que se mueve en eje y 
	if state == STATE.FLY:
		if Input.is_action_pressed("ui_down"):
			direction.y = 1 
		if Input.is_action_pressed("ui_up"):
			direction.y = -1
	else:
		if state == STATE.FALLING:
			direction.y = 1
		
		if Input.is_action_pressed("ui_up"):
			if state == STATE.WALK:
				print("jump")
				state = STATE.JUMPING
	#Quiciera que hubiera un 
	
	if direction.length() <= 0.0:
		curveValue -= delta
		curveValue = clamp(curveValue, end_curve.min_value, end_curve.max_value)
		# Invertir el valor para la curva end
		var inverted_value = end_curve.max_value - (curveValue - end_curve.min_value)
		accel = end_curve.sample(inverted_value)
	else:
		curveValue += delta
		curveValue = clamp(curveValue, start_curve.min_value, start_curve.max_value)
		accel = start_curve.sample(curveValue)
		lastDirection = direction
	
	if Input.is_action_pressed("sprint"):
		maxVel = baseMaxVel * (1 + sprint * 0.01)
	else:
		maxVel = baseMaxVel

func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		state = STATE.WALK
	elif !is_on_floor() and state != STATE.FLY:
		state = STATE.FALLING
	
	#match state:
		#STATE.FALLING:
			#lastDirection.y = 1 
	
	if (is_on_floor() and direction.y > 0) or (is_on_ceiling() and direction.y < 0):
		lastDirection.y = 0
	
	if (direction.x > 0 and get_wall_adjusment() < 0) or (direction.x < 0 and get_wall_adjusment() > 0):
		lastDirection.x = 0
	
	if state == STATE.FLY:
		velocity = lastDirection.normalized() * (accel*maxVel) * delta
	else:
		velocity.x = lastDirection.x * (accel*maxVel) * delta
		velocity.y = lastDirection.y * gravity * delta
		pass
	move_and_slide()
	move_and_collide(velocity)

func get_wall_adjusment()-> float:
	return get_wall_normal().x if is_on_wall() else 0.0

extends CharacterBody2D

enum STATE { WALK, FLY, STARTJUMP, JUMPING, FALLING }
var state = STATE.WALK

var maxJumpAir = 1
var canFly = true

var direction : Vector2 = Vector2.ZERO
var lastDirection : Vector2 = Vector2.RIGHT

#Gavity mode 
var yVelocity = 0.0 #velocidad del personaje
var gravity = 8.2 #Gravedad normal 
var jumpGravity = 4.1 #Gravedad durante el salto
var jumpForce = -150.0 #Fuerza inicial del salto
var downForce = 0.0 #Fuerza adicional del salto

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
		
		if Input.is_action_just_pressed("ui_down") and Input.is_action_pressed("ui_accept"):
			direction.y = 1
			yVelocity = 0.0
			state = STATE.FALLING
	else:
		direction.y = 1 #Gravity direction
		if Input.is_action_pressed("jump") and state == STATE.STARTJUMP:
			state = STATE.JUMPING
		if Input.is_action_just_released("jump") and state == STATE.JUMPING:
			state = STATE.FALLING
		if Input.is_action_just_pressed("jump") and state == STATE.WALK and state != STATE.FALLING:
			state = STATE.STARTJUMP
		elif Input.is_action_just_pressed("jump") and (state == STATE.JUMPING or state == STATE.FALLING) and canFly:
			canFly = false
			state = STATE.FLY
	
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
	
	if state == STATE.FLY:
		if (is_on_floor() and direction.y > 0) or (is_on_ceiling() and direction.y < 0):
			lastDirection.y = 0
		if (direction.x > 0 and get_wall_adjusment() < 0) or (direction.x < 0 and get_wall_adjusment() > 0):
			lastDirection.x = 0
		velocity = lastDirection.normalized() * (accel*maxVel) * delta
		move_and_slide()
		move_and_collide(velocity)
	else:
		#La lógica de caida.
		if state == STATE.STARTJUMP:
			yVelocity = jumpForce - jump_impulse()
		elif state == STATE.JUMPING:
			yVelocity += jumpGravity
		elif state == STATE.FALLING:
			yVelocity += gravity
		
		#No sprint falling or jumping
		if state != STATE.WALK:
			maxVel = baseMaxVel
		
		velocity.x = lastDirection.x * (accel*maxVel) * delta
		velocity.y = lastDirection.y * yVelocity * delta
		
		move_and_slide()
		move_and_collide(velocity)
		
		if is_on_floor():
			canFly = true
			state = STATE.WALK
		elif !is_on_floor() and velocity.y >= 0.0:
			state = STATE.FALLING

func get_wall_adjusment()-> float:
	return get_wall_normal().x if is_on_wall() else 0.0

func jump_impulse()-> float:
	return maxVel*0.2 if maxVel > baseMaxVel else 0.0

func print_state():
	match state:
		STATE.WALK:
			print("Walk")
		STATE.FLY:
			print("Fly")
		STATE.JUMPING:
			print("Jumping")
		STATE.FALLING:
			print("Fallig")
		STATE.STARTJUMP:
			print("START JUMP")

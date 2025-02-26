extends CharacterBody2D

enum STATE { WALK, FLY, STARTJUMP, JUMPING, FALLING }
var state = STATE.WALK

var maxJumpAir = 1
var canFly = true

var direction : Vector2 = Vector2.ZERO
var lastDirection : Vector2 = Vector2.RIGHT

#Gavity mode 
var yVelocity = 0.0 #velocidad del personaje
var gravity = 15.0 #Gravedad normal 
var jumpGravity = 6.1 #Gravedad durante el salto
var jumpForce = -200.0 #Fuerza inicial del salto
var downForce = 0.0 #Fuerza adicional del salto

var baseMaxVel
@export var maxVel = 130.0
@export_range(0, 100, 0.1) var sprint : float = 25

@export var start_curve : Curve = null
@export var end_curve : Curve = null

#Attack decay sustain realeace
var accel = 0.0
var curveValue = 0.0

#Sprite controller
@onready var spr = $Sprite2D
var totalAnimSprites = 4
var animDelay = 1.0
var animTimer = 0.0

#Collisions specs
var wallNormal = 0.0
var cielNormal = 0.0

func _ready() -> void:
	baseMaxVel = maxVel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if direction.length() <= 0.0 or (state != STATE.FALLING and state != STATE.FLY and direction.x == 0):
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
	anim_sprites(delta)

func _physics_process(delta: float) -> void:
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
		spr.scale.x = 1
		
		if lastDirection.x != direction.x and state != STATE.FLY:
			curveValue = 0.0
		 
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
		spr.scale.x = -1
		
		if lastDirection.x != direction.x and state != STATE.FLY:
			curveValue = 0.0
	
	#Reset al cambiar la direccion
	
	
	
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
			show_sprite_state()
	else:
		direction.y = 1 #Gravity direction
		if Input.is_action_pressed("jump") and state == STATE.STARTJUMP:
			state = STATE.JUMPING
		if Input.is_action_just_released("jump") and state == STATE.JUMPING:
			state = STATE.FALLING
		if Input.is_action_just_pressed("jump") and state == STATE.WALK and state != STATE.FALLING:
			state = STATE.STARTJUMP
		elif Input.is_action_just_pressed("fly") and (state == STATE.JUMPING or state == STATE.FALLING) and canFly:
			canFly = false
			state = STATE.FLY
			show_sprite_state()
	
	if Input.is_action_pressed("sprint"):
		maxVel = baseMaxVel * (1 + sprint * 0.01)
	else:
		maxVel = baseMaxVel
	
	if state == STATE.FLY:
		if (is_on_floor() and direction.y > 0) or (is_on_ceiling() and direction.y < 0):
			lastDirection.y = 0
		if (direction.x > 0 and get_wall_adjusment() < 0) or (direction.x < 0 and get_wall_adjusment() > 0):
			lastDirection.x = 0
		velocity = lastDirection.normalized() * (accel*maxVel) * delta
		move_and_slide()
		move_and_collide(velocity)
	else:
		#La lógica de caida
		if state == STATE.STARTJUMP:
			yVelocity = jumpForce - jump_impulse()
		elif state == STATE.JUMPING:
			yVelocity += jumpGravity
		elif state == STATE.WALK:
			yVelocity = 0.0
		else:
			yVelocity += gravity
			yVelocity = clamp(yVelocity, 0.0, 1200)
		
		#No sprint falling or jumping
		if state != STATE.WALK:
			maxVel = baseMaxVel
		
		#Tomar el normal de la pared para no quedarse pegado en ella.
		if wallNormal != 0.0 and direction.x != 0.0:
			lastDirection.x = 0.0
		
		#No pegarse al techo
		if cielNormal == 1:
			lastDirection.y = -1
		
		velocity.x = lastDirection.x * (accel*maxVel) * delta
		velocity.y = lastDirection.y * yVelocity * delta
		
		var move = move_and_collide(velocity, false, 0.08, true)
		
		if get_normal_coll(move).y == -1: #in the floor
			canFly = true
			state = STATE.WALK
			yVelocity = 0.0
			show_sprite_state()
		else:
			if state == STATE.JUMPING or state == STATE.STARTJUMP:
				if velocity.y > 0:
					state = STATE.FALLING
			else:
				state = STATE.FALLING
				
				pass
		
		#Get normal wall
		wallNormal = get_normal_coll(move).x
		cielNormal = get_normal_coll(move).y
		
		#print(lastDirection)
		#print(get_state())

func get_normal_coll(collision_move: KinematicCollision2D) -> Vector2:
	if collision_move != null:
		return collision_move.get_normal()
	return Vector2.ZERO

func get_wall_adjusment()-> float:
	return get_wall_normal().x if is_on_wall() else 0.0

func jump_impulse()-> float:
	return maxVel*0.2 if maxVel > baseMaxVel else 0.0

func show_sprite_state():
	match state:
		STATE.WALK:
			spr.frame_coords.y = 0
		STATE.FLY:
			spr.frame_coords.y = 1
		STATE.JUMPING:
			pass
		STATE.FALLING:
			spr.frame_coords.y = 0
		STATE.STARTJUMP:
			pass

func get_state()-> String:
	match state:
		STATE.WALK:
			return "Walk"
		STATE.FLY:
			return "Fly"
		STATE.JUMPING:
			return "Jumping"
		STATE.FALLING:
			return "Falling"
		STATE.STARTJUMP:
			return "Jump"
		_:
			return "State"


func anim_sprites(delta)-> void:
	animTimer += delta
	if animTimer >= animDelay:
		animTimer = 0.0
		var cur_frame = spr.frame_coords.x
		spr.frame_coords.x = (cur_frame + 1) % totalAnimSprites
	
	pass

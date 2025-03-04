extends CharacterBody2D
#PARA un viewport de 320*180, tamaño de sprite 32*32

var SPEED = 300.0
var JUMP = 100.0*2
var GRAVITY = 980*2
var GRAVITY_FALL = 2000

var JUMP_IMPULSE = 800*2
var can_impulse_jump = false

var jump_timer = 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		#velocity += get_gravity() * delta
		jump_timer += delta
		$Timer.text = "%.4f" % jump_timer
	else :
		jump_timer = 0.0
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP
		can_impulse_jump = true
	
	if velocity.y < 0.0:
		if Input.is_action_just_released("jump"):
			can_impulse_jump = false
		if Input.is_action_pressed("jump") and can_impulse_jump:
			velocity.y -=  JUMP_IMPULSE * delta
		
		velocity.y += GRAVITY * delta
		
	else:
		velocity.y += GRAVITY_FALL * delta
		
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	print(velocity)
	
	move_and_slide()

func flying():
	pass

func walking():
	pass

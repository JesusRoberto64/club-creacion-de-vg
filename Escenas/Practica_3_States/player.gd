extends CharacterBody2D
#PARA un viewport de 320*180, tamaño de sprite 32*32
@export_range(0.0, 1000) var MAX_SPEED : float = 150.0
@onready var mov_curve = $CurveMovement 

@export_range(0.0,1000) var GRAVITY : float = 62.72
@export_range(0.0,1000) var GRAVITY_FALL : float = 63
@export_range(0.0,1000) var JUMP : float = 400.0
@export_range(0.0,1000) var JUMP_IMPULSE : float = 48
var can_impulse_jump = false
var jump_timer = 0.0

@export_range(0.0,1000) var SPRINT : float = 150.0
@onready var sprint_curve = $CurveSprint
var sprint_val = 0.0

var current_direction = 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		jump_timer += delta
		$Timer.text = "%.4f" % jump_timer
	else :
		can_impulse_jump = false
		jump_timer = 0.0
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP
		can_impulse_jump = true
	
	if velocity.y < 0.0:
		if Input.is_action_just_released("jump"):
			can_impulse_jump = false
		if Input.is_action_pressed("jump") and can_impulse_jump:
			velocity.y -=  JUMP_IMPULSE
		
		velocity.y += GRAVITY
		
	else:
		velocity.y += GRAVITY_FALL
		
	
	var direction : float = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0.0:
		if current_direction != direction:
			mov_curve.reset()
			sprint_curve.reset()
		
		current_direction = direction
		mov_curve.set_attack_sample(delta)
	else:
		mov_curve.set_releace_sample(delta)
	
	
	#Sprint
	if Input.is_action_pressed("sprint") and direction:
		sprint_curve.set_attack_sample(delta)
	else:
		sprint_curve.set_releace_sample(delta)
	
	
	
	velocity.x = current_direction * ((MAX_SPEED*mov_curve.sample_value) + (SPRINT*sprint_curve.sample_value))
	
	
	move_and_slide()

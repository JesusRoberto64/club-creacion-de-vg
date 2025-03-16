extends CharacterBody2D

# ===== Configuración de Movimiento =====
@export_category("Movement Settings")
@export_range(0.0, 1000.0) var max_speed: float = 150.0
@export_range(0.0, 1000.0) var sprint_speed: float = 150.0
@onready var acceleration_curve = $CurveMovement
@onready var sprint_curve = $CurveSprint 

# ===== Configuración de Salto y Gravedad =====
@export_category("Jump/Gravity Settings")
@export_range(0.0, 1000.0) var jump_force: float = 400.0
@export_range(0.0, 1000.0) var jump_impulse: float = 48.0
@export_range(0.0, 1000.0) var base_gravity: float = 62.72
@export_range(0.0, 1000.0) var fall_gravity: float = 63.0

# ===== Variables de Estado =====
var current_direction: int = 1
var can_impulse_jump: bool = false
var is_sprinting: bool = false
var jump_hold_timer: float = 0.0

@onready var ui_timer: Label = $Timer

func _physics_process(delta: float) -> void:
	#Handle_gravity
	var gravity = base_gravity if velocity.y < 0 else fall_gravity
	if not is_on_floor():
		velocity.y += gravity
	
	if get_platform_velocity().length() > 0.0:
		#$Karel.offset.y = get_platform_velocity().y * delta
		#velocity.y = get_platform_velocity().y * delta
		#print(get_platform_velocity(), " character")
		pass
	
	#handle_jump_input()
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		can_impulse_jump = true
		jump_hold_timer = 0.0
	
	handle_jump_impulse()
	
	# handle movement input
	var input_direction = Input.get_axis("ui_left", "ui_right")
	if input_direction != 0:
		update_direction(input_direction)
		acceleration_curve.set_attack_sample(delta)
	else:
		acceleration_curve.set_releace_sample(delta)
	
	handle_sprint_input(delta)
	
	velocity.x = add_movement()
	move_and_slide()
	
	if !is_on_floor():
		update_ui(delta)
	else:
		jump_hold_timer = 0.0
	
	$Karel.scale.x = current_direction

# ===== Funciones Modularizadas =====
func handle_jump_impulse() -> void:
	if can_impulse_jump and Input.is_action_pressed("jump") and velocity.y < 0:
		velocity.y -= jump_impulse
	elif Input.is_action_just_released("jump"):
		can_impulse_jump = false

func handle_sprint_input(delta: float) -> void:
	is_sprinting = Input.is_action_pressed("sprint") and Input.get_axis("ui_left", "ui_right") != 0
	if is_sprinting:
		sprint_curve.set_attack_sample(delta)
	else:
		sprint_curve.set_releace_sample(delta)

func update_direction(new_direction: int) -> void:
	if new_direction != current_direction:
		current_direction = new_direction
		reset_curves()

func reset_curves() -> void:
	acceleration_curve.reset()
	sprint_curve.reset()

func add_movement() -> float:
	var movement_speed = (max_speed * acceleration_curve.sample_value) + (sprint_speed * sprint_curve.sample_value)
	return current_direction * movement_speed

func update_ui(delta: float) -> void:
	jump_hold_timer += delta
	ui_timer.text = "%.4f" % jump_hold_timer

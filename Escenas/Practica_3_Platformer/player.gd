extends CharacterBody2D

# ===== Configuración de Movimiento =====
@export_category("Movement Settings")
@export_range(0.0, 1000.0) var speed : float = 150.0
@export_range(0.0, 1000.0) var max_speed: float = 300.0
@export_range(0.0, 1000.0) var sprint_speed: float = 150.0
@onready var acceleration_curve = $CurveMovement
@onready var sprint_curve = $CurveSprint 
var accel_x : float = 0.0

# ===== Configuración de Salto y Gravedad =====
@export_category("Jump/Gravity Settings")
@export_range(0.0, 1000.0) var jump_force: float = 400.0
@export_range(0.0, 1000.0) var jump_impulse: float = 48.0
@export_range(0.0, 1000.0) var base_gravity: float = 62.72
@export_range(0.0, 1000.0) var fall_gravity: float = 63.0

# ===== Variables de Estado =====
var current_direction: float = 1.0
var can_impulse_jump: bool = false
var is_sprinting: bool = false
var jump_hold_timer: float = 0.0

@onready var ui_timer: Label = $Timer

# Golpes y desplazamientos
var is_hited = false
var hit_direction: Vector2 = Vector2.ZERO

# Comobo lógica
var combo : int = 0
@onready var combo_lab : Label = $Combo
@onready var combo_anim: AnimationPlayer = $Combo/AnimationPlayer
signal change_combo(_combo)

#STATE LOGIC
var stop_sate = false

func _physics_process(delta: float) -> void:
	if stop_sate: return
	
	#Handle_gravity
	var gravity = base_gravity if velocity.y < 0 else fall_gravity
	if not is_on_floor():
		velocity.y += gravity
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		can_impulse_jump = true
		jump_hold_timer = 0.0
	
	# Cuando dejas presionado el boton de en el aire salto
	handle_jump_impulse()
	
	# Golpe de salto
	
	var was_combo : bool = false
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("Burbuja"):
			collider.pop()
			if collision.get_normal().y < 0.0: 
				velocity.y = -jump_force
				can_impulse_jump = true
				jump_hold_timer = 0.0
				set_combo()
				was_combo = true
				break
			elif collision.get_normal().x != 0.0:
				hit_impulse(collision.get_normal())
	
	if !was_combo and is_on_floor():
		combo = 0
	
	# handle movement input
	var mov : float = Input.get_axis("ui_left", "ui_right")
	
	#this accel button function
	sprint_input(delta, mov)
	
	if mov != 0.0:
		current_direction = mov
		acceleration_curve.set_attack_sample(delta)
		accel_x += acceleration_curve.sample_value * speed * mov
		var sum_speed = max_speed + (sprint_speed * sprint_curve.sample_value)
		accel_x = clamp(accel_x, -sum_speed, sum_speed)
	else:
		acceleration_curve.set_releace_sample(delta)
		accel_x = accel_x * acceleration_curve.sample_value
	
	if is_hited:
		velocity.x = hit_direction.x * 500.0
		reset_curves()
		accel_x = 0.0
		is_hited = false
	else:
		velocity.x = accel_x
	
	move_and_slide()
	
	#UI UPDATE
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

func hit_impulse(dir: Vector2) -> void:
	hit_direction = dir
	is_hited = true

func sprint_input(delta: float, mov) -> void:
	is_sprinting = Input.is_action_pressed("sprint")
	if is_sprinting and mov != 0.0:
		sprint_curve.set_attack_sample(delta)
	else:
		sprint_curve.set_releace_sample(delta)

func reset_curves() -> void:
	acceleration_curve.reset()
	sprint_curve.reset()

func update_ui(delta: float) -> void:
	jump_hold_timer += delta
	ui_timer.text = "%.4f" % jump_hold_timer

func set_combo() -> void:
	combo += 1
	combo_lab.text = "X " + str(combo)
	combo_anim.play("combo_out")
	change_combo.emit(combo)

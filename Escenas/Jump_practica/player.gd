extends Sprite2D

var screen_size 

@export_range(0.0, 1000) var gravity : float = 240 
@export_range(0.0, 1000)var gravity_fall : float = 450
@export_range(0.0, 1000)var jump_force : float = 121 
@export_range(0.0, 1000)var jump : float = 115

var can_jump = false
var can_impulse_jump = false

@export var kirby_jump : bool = false
@export var kirby_curve : Curve = null
var curve_force_value = 0.0
var curve_fall_value = 0.0

var velocity = 0.0

var jump_timer = 0.0
var canSetTimer = false

@onready var timerLab = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and can_jump:
		velocity = -jump
		can_jump = false
		can_impulse_jump = true
		jump_timer = 0.0
		curve_fall_value = 0.0
	
	if velocity < 0.0: # Jumping 
		#impulso para llegar mas lejos 
		if Input.is_action_just_released("jump"):
			can_impulse_jump = false
		if Input.is_action_pressed("jump") and can_impulse_jump:
			velocity -= jump_force * delta
		
		if !kirby_jump:
			velocity += gravity * delta
		else :
			kirby_force(delta)
		
	else: # Falling
		if !kirby_jump:
			velocity += gravity_fall * delta
		else:
			kirby_falling(delta)
	
	
	position.y += velocity * delta
	
	# Colisiones con suelo
	if position.y > screen_size.y - (screen_size.y/4):
		position.y = screen_size.y - (screen_size.y/4)
		can_jump = true
		velocity = 0.0
		curve_force_value = 0.0
	else:
		jump_timer += delta
		timerLab.text = "%.4f" % jump_timer

func kirby_force(delta):
	curve_force_value += delta
	curve_force_value = min(curve_force_value,1.0)
	velocity += gravity * kirby_curve.sample(curve_force_value) * delta

func kirby_falling(delta):
	curve_fall_value += delta
	curve_fall_value = min(curve_fall_value,1.0)
	velocity += gravity_fall * kirby_curve.sample(curve_fall_value) * delta

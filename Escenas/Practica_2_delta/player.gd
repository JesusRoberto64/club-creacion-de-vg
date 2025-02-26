extends Sprite2D

var screen_size 

var can_jump = false
var gravity = 90 #90 # delta # 0.028 #No delta 
var jump_force = -108 #-108 # delta # -70 # No delta
var velocity = 0.0

var jump_timer = 0.0
var canSetTimer = false

@onready var timerLab = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("jump") and can_jump:
		velocity = jump_force 
		can_jump = false
		jump_timer = 0.0
	
	velocity += gravity * delta
	position.y += velocity * delta
	
	# Colisiones con suelo
	if position.y > screen_size.y - (screen_size.y/4):
		position.y = screen_size.y - (screen_size.y/4)
		can_jump = true
		velocity = 0.0
	else:
		jump_timer += delta
		timerLab.text = "%.4f" % jump_timer
	
	

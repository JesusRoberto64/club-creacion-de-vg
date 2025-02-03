extends CharacterBody2D

enum STATE {FLOOR, FLY, FALLING}
var maxJumpAir = 1
var jumpedAir = 0

var direction : Vector2 = Vector2(1.0, 0.0)
var gravity = Vector2(0.0, 1.0) * 5.0
var maxVel = 100.0

func _ready() -> void:
	#motion_mode = MOTION_MODE_FLOATING
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = 1 + get_wall_adjusment() 
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -1 + get_wall_adjusment()
	
	if Input.is_action_pressed("ui_down") and !is_on_floor():
		velocity.y = 1 
	elif Input.is_action_pressed("ui_up") and !is_on_ceiling():
		velocity.y = -1
	
	velocity = velocity.normalized() * maxVel * delta
	move_and_slide()
	move_and_collide(velocity)

func get_wall_adjusment()-> float:
	return get_wall_normal().x if is_on_wall() else 0.0

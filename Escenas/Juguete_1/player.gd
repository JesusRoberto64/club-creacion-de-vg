extends CharacterBody2D

@onready var walk_curve = $Walk
@onready var sprint_curve = $Sprint
var max_vel = 100

var sprint = 0.0
var max_sprint = 100
var accel = 0.0
var direction = 1

func _physics_process(delta: float) -> void:
	var dir = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	if dir != 0:
		accel = walk_curve.get_attack(delta)
		
		if direction != dir:
			walk_curve.reset_curve()
			sprint_curve.reset_curve()
		
		direction = dir
	else:
		accel = walk_curve.get_releace(delta)
	
	
	
	if Input.is_action_pressed("sprint"):
		sprint = sprint_curve.get_attack(delta) * max_sprint
	else:
		sprint = sprint_curve.get_releace(delta) * max_sprint
	
	print(dir)
	var move = Vector2(direction*((max_vel*accel) + sprint)*delta, 0.0)
	move_and_collide(move)
	#sprint
	#reset curve
	

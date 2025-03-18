extends CharacterBody2D

enum STATE {WALKING , HOOKED}
var cur_state = STATE.WALKING
var cur_direction = 1

const SPEED = 300.0
const JUMP_VELOCITY = 400.0

#State Control
@onready var hook : RayCast2D = $Hook
var ray_lenght = Vector2(0.0, 0.0)
var ray_max_lenght = Vector2(50.0, -50.0)
var launching = false
var tween: Tween

# Hook Movement
var swing_movement := Vector2.ZERO
var swing_speed : float = 8.0
var radius : float = 0.0
var max_radius : float = 50
var radian : float = 0.0
var anchor_pos : Vector2

var impulse = 0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("action") and !launching:
		launching = true
		hook.enabled = true
		ray_max_lenght.x = abs(ray_max_lenght.x) * cur_direction
		start_tween()
	
	if launching:
		hook.target_position = ray_lenght
	
	
	# STATE WITH MATCH
	match cur_state:
		STATE.WALKING:
			# Add the gravity.
			if not is_on_floor():
				velocity += get_gravity() * delta
			else:
				impulse = 0.0
			
			# Handle jump.
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = -JUMP_VELOCITY
			
			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var direction := Input.get_axis("ui_left", "ui_right")
			if direction:
				velocity.x = direction * SPEED
				cur_direction = direction
			else:
				velocity.x = impulse
				impulse = move_toward(impulse, 0.0, delta)
			pass
		STATE.HOOKED:
			radius += delta * swing_speed
			radius = min(radius, max_radius)
			radian += delta * swing_speed * cur_direction
			
			swing_movement.x = sin(radian) * radius
			swing_movement.y = cos(radian) * radius
			position = swing_movement + anchor_pos
			
			hook.target_position = anchor_pos - hook.global_position
			
			if Input.is_action_just_pressed("jump"):
				set_collision_mask_value(1, true)
				cur_state = STATE.WALKING
				var impulse_dir = hook.target_position.normalized()
				velocity.y = -impulse_dir.y * JUMP_VELOCITY
				impulse = -impulse_dir.x * JUMP_VELOCITY
				hook.target_position = Vector2.ZERO
				ray_lenght = Vector2.ZERO
				launching = false
				radius = 0.0
				pass
			pass
	
	move_and_slide()
	
	$Karel.scale.x = cur_direction

func start_tween():
	tween = create_tween()
	tween.tween_property(self, "ray_lenght", ray_max_lenght, 0.15).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "ray_lenght", Vector2.ZERO, 0.25).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", _on_tween_end)
	pass

func _on_tween_end():
	launching = false
	hook.enabled = false
	ray_lenght = Vector2.ZERO
	pass

func cancel_tween():
	tween.kill()
	hook.enabled = false

func _on_hook_hooked(_anchor_pos: Vector2) -> void:
	anchor_pos = _anchor_pos
	cur_state = STATE.HOOKED
	set_collision_mask_value(1, false)
	velocity = Vector2.ZERO
	
	# WORKS only a -45 Degress angle
	if cur_direction > 0.0:
		radian = hook.target_position.angle() 
	else:
		radian = hook.target_position.angle() - PI
	
	
	radius = _anchor_pos.distance_to(position)
	cancel_tween()

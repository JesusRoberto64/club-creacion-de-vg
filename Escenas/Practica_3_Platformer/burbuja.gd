extends AnimatableBody2D

var life_time : float = 5.0
var direction : Vector2 = Vector2.UP
var speed : float = 10.0 

var destroyed = false

var life_timer = 0.0
var life_timer_limit = 3.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if destroyed:
		queue_free()
	position += direction * speed * delta
	
	life_time += delta
	if life_timer > life_timer_limit:
		destroyed = true

func pop() -> void:
	set_collision_layer_value(2, false)
	$AnimMap.hide()
	destroyed = true

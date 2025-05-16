extends AnimatableBody2D

var life_time : float = 0.0
var life_time_limit : float = 5.0

var direction : Vector2 = Vector2.UP
var speed : float = 10.0 

var destroyed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if destroyed:
		queue_free()
	position += direction * speed * delta
	
	life_time += delta
	if life_time > life_time_limit:
		destroyed = true

func pop() -> void:
	set_collision_layer_value(2, false)
	$AnimMap.hide()
	destroyed = true

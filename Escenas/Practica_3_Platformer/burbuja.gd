extends AnimatableBody2D

var life_time : float = 5.0
var direction : Vector2 = Vector2.UP
var speed : float = 10.0 

var destroyed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if destroyed:
		queue_free()
	position += direction * speed * delta

func pop() -> void:
	set_collision_layer_value(2, false)
	$AnimMap.hide()
	destroyed = true

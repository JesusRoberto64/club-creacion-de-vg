extends Area2D

var direction = Vector2(1.0,1.0).normalized()
@onready var trace = $Trace/Line2D
@export var velocity = 60.0

signal sub_bullet

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	trace.add_point(position)
	if trace.points.size() > 80:
		trace.remove_point(0)
	position += direction * velocity * delta 

func set_direction(dir: Vector2):
	direction = dir
	pass

func _on_timer_timeout() -> void:
	sub_bullet.emit()
	queue_free()

func connect_life(_owner):
	if _owner.has_method("sub_bullet"):
		connect("sub_bullet", _owner.sub_bullet)


func _on_body_entered(_body: Node2D) -> void:
	sub_bullet.emit()
	queue_free()

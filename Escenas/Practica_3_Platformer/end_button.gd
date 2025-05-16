extends Area2D

signal pressed

func _on_body_entered(_body: Node2D) -> void:
	$Btn.frame = 1
	pressed.emit()
	set_collision_mask_value(2, false)

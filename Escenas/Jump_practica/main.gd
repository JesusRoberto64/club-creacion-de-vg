extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Label.text = "FPS: %02d" % [Engine.get_frames_per_second()]
	
	if Input.is_action_just_released("ui_left"):
		Engine.max_fps -= 10
	elif Input.is_action_just_released("ui_right"):
		Engine.max_fps += 10
	
	Engine.max_fps = clamp(Engine.max_fps, 10, 60)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

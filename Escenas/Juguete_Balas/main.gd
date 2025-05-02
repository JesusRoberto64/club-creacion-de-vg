extends Node2D

var bullets : int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$CanvasLayer/FPS.text = "FPS: %02d" % [Engine.get_frames_per_second()]
	$CanvasLayer/Bullets.text = "Bullets: " + str(bullets)   
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func add_bullets(_bullets: int):
	bullets += _bullets

func sub_bullet():
	bullets -= 1

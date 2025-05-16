extends Node2D

var max_combo = 0

@onready var end_button = $EndButton

func _ready() -> void:
	$Player.connect("change_combo", change_combo)
	end_button.connect("pressed", pressed_complete)
	
	#SET UI
	$CanvasLevel/Nivel.text = "Nivel " + str(Singleton.cur_level + 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$CanvasLevel/Label2.text = "FPS: %02d" % [Engine.get_frames_per_second()]
	
	if Input.is_key_pressed(KEY_Q):
		Engine.max_fps -= 10
	elif Input.is_key_pressed(KEY_E):
		Engine.max_fps += 10
	
	Engine.max_fps = clamp(Engine.max_fps, 10, 60)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func change_combo(combo)-> void:
	if combo > max_combo:
		max_combo = combo
		$CanvasLevel/maxCombo.text = "Max Combo: " + str(max_combo)

func pressed_complete() -> void:
	$CanvasLevel/Completado.show()
	$Player.stop_sate = true
	var tween = get_tree().create_tween()
	tween.tween_callback(next_level).set_delay(1.0)

func next_level() -> void:
	var level : String = Singleton.get_next_level()
	get_tree().change_scene_to_file(level)

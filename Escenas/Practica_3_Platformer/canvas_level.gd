extends CanvasLayer

@onready var anim = $AnimationPlayer

func to_color() -> void:
	anim.play("to_color")

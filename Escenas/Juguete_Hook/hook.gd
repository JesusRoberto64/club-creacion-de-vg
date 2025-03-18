extends RayCast2D

@onready var chain : Line2D = $Line2D

signal hooked(anchor_pos: Vector2)

func _ready() -> void:
	collide_with_areas = true

func _physics_process(_delta: float) -> void:
	if enabled and is_colliding():
		hooked.emit(get_collider().position)
	chain.set_point_position(0, target_position)
	

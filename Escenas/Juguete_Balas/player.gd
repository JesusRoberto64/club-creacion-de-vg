extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var accel = Vector2.ZERO
var max_accel = 10000.0
var direction := Vector2.ZERO

var Bullet = preload("res://Escenas/Juguete_Balas/Bullet.tscn")
@export var max_bullets = 24
var bullet_offset :int = 0
var bullet_rafaga = 0.0 #radians
var interval_rafaga = (2.0*PI) / max_bullets

signal add_bullets(bullets: int)

func _physics_process(delta: float) -> void:
	var mov = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if mov.length() != 0.0: direction = mov
	accel = mov * 10000.0 * delta
	velocity = accel
	
	
	move_and_slide()

func _process(delta: float) -> void:
	#Al rededor
	if Input.is_action_just_pressed("attack_1"):
		var interval = (2.0*PI) / max_bullets
		var radian = 0.0 + (bullet_offset * (interval/2.0))
		for i in max_bullets:
			radian += interval
			var dir =  Vector2(sin(radian), cos(radian))
			var bullet_inst = Bullet.instantiate()
			owner.add_child(bullet_inst)
			bullet_inst.connect_life(owner)
			bullet_inst.position = position
			bullet_inst.set_direction(dir)
		add_bullets.emit(max_bullets)
		bullet_offset = (bullet_offset + 1) % 2
		
	
	#Dirigido
	if Input.is_action_just_pressed("attack_2"):
		var radian_dir = direction.angle_to(Vector2.DOWN)
		var bullet_range = PI/2.0
		var interval = bullet_range / max_bullets
		var radian = radian_dir - (bullet_range/2.0) + (bullet_offset * (interval/2.0))
		for i in max_bullets:
			radian += interval
			var dir =  Vector2(sin(radian), cos(radian))
			var bullet_inst = Bullet.instantiate()
			owner.add_child(bullet_inst)
			bullet_inst.connect_life(owner)
			bullet_inst.position = position
			bullet_inst.set_direction(dir)
		add_bullets.emit(max_bullets)
		bullet_offset = (bullet_offset + 1) % 2
	
	#Rafaga
	if Input.is_action_just_pressed("attack_3"):
		bullet_rafaga += interval_rafaga
		var dir =  Vector2(sin(bullet_rafaga), cos(bullet_rafaga))
		var bullet_inst = Bullet.instantiate()
		owner.add_child(bullet_inst)
		bullet_inst.connect_life(owner)
		bullet_inst.position = position
		bullet_inst.set_direction(dir)
		add_bullets.emit(1)

extends Node
class_name curves

@export var attack_curve : Curve =  null
@export var releace_curve : Curve =  null
var curve_time_value = 0.0
var sample_value = 0.0

func set_attack_sample(delta) -> void:
	curve_time_value += delta
	curve_time_value = min(curve_time_value, 1.0)
	sample_value = attack_curve.sample(curve_time_value)

func set_releace_sample(delta) -> void:
	curve_time_value -= delta
	curve_time_value = max(curve_time_value, 0.0)
	# Para invertir la curva y manipularla en el inspector de forma mas intuitiva
	var invert_value = 1.0 - curve_time_value
	sample_value = releace_curve.sample(invert_value)

func reset()-> void:
	curve_time_value = 0.0
	#sample_value = 0.0

func get_value()-> float:
	return sample_value

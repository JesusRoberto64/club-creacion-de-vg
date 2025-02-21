extends Node
class_name VelosityCurve

@export var attack_curve : Curve = null 
@export var releace_curve : Curve = null

var curve_value = 0.0
# Duración del ataque en segundos (puede ajustarse)
@export var attack_duration = 1.0
@export var releace_duration = 1.0

#Give time to return the sampler value, x axis = time y axis = value to return
#Darle tiempo para regresar el valor sample de la curva donde eje x = tiempo y eje y = valor a regresar
func get_attack(delta)-> float:
	if attack_duration > 0.0:
		curve_value += delta / attack_duration
	else:
		curve_value = 1.0
	
	curve_value = min(curve_value, 1.0)
	return attack_curve.sample(curve_value)

func get_releace(delta)-> float:
	if attack_duration > 0.0:
		curve_value -= delta / releace_duration
	else:
		curve_value = 1.0
	
	curve_value = max(curve_value, 0.0)
	# A 1.0 le restas el curve_value para invertir la curva y poder graficarla a la inversa en el inspector
	var inverted_curve = 1.0 - curve_value
	return releace_curve.sample(inverted_curve)

func reset_curve():
	curve_value = 0.0

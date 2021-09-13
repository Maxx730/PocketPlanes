extends Node2D

enum PATH {DEFAULT, WIGGLE}

export(int) var FloatDistance = 100
export(int) var FloatSpeed = 3
export(int) var Points = 100
export(PATH) var Type = PATH.DEFAULT
export(bool) var Addition = true

func _ready():
	$Label.text = GetValueDir() + String(Points)

func _process(delta):
	position.y -= 1 * delta * FloatSpeed
	
	match Type:
		PATH.WIGGLE:
			pass
		PATH.DEFAULT:
			pass
	
	if position.y < -FloatDistance:
		queue_free()
	

func GetValueDir():
	if Addition:
		return "+"
	else:
		return "-"

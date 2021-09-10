extends Node2D

export(float) var ExpTimeout = 3.5
var ExpStart = 0

func _process(delta):
	if ExpStart > ExpTimeout:
		queue_free()
	else:
		ExpStart += delta

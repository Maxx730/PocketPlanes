extends Particles2D

var Timeout = 0.1
var TimeStart = 0

func _process(delta):
	if TimeStart > Timeout:
		queue_free()
	else:
		TimeStart += delta

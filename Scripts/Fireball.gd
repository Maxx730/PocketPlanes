extends Particles2D

func _draw():
	draw_line(Vector2(0, 0), -transform.y * 30, Color.purple)
	
func _process(delta):
	update()
	
	position += transform.x * delta * 2
	if scale.x > 0:
		scale.x -= 1 * delta / 4
		scale.y -= 1 * delta / 4

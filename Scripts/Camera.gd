extends Camera2D

export(int) var FollowSpeed = 10

var Target = null

func _process(delta):
	if Target != null:
		MoveToPoint(Target.position, delta)
		
func MoveToPoint(point, delta):
	position = Vector2(lerp(position.x, point.x, delta * FollowSpeed), lerp(position.y, point.y, delta * FollowSpeed))

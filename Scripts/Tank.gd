extends RigidBody2D

var Target = null

func _ready():
	pass

func _draw():
	if Target != null:
		var dir = Target.global_position - global_position
		draw_line(Vector2(0, 0), dir.normalized() * 30, Color.white)

func _process(delta):
	update()
	LookAtTarget(delta)

func _physics_process(delta):
	pass

func RangeEntered(body):
	if body.is_in_group("Plane"):
		Target = body

func RangeExited(body):
	if body == Target:
		Target = null

func LookAtTarget(delta):
	if $Turret != null && Target != null:
		var dir = Target.global_position - global_position
		var angle = dir.angle()
		$Turret.global_rotation = lerp_angle($Turret.global_rotation, angle, delta * 100)
		
func HandleCollisions(bodies):
	for body in bodies:
		if body.is_in_group("Shot"):
			body.queue_free()

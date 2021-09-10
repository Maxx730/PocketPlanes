extends KinematicBody2D

onready var ViewportSize = get_viewport().size

export(int) var EntranceSpeed = 1
export(int) var BottomOffset = 50
export(int) var ShadowDistance = 20
export(int) var Speed = 200
export(int) var TurnSpeed = 1

var Cam = null
var FinishedSpawn = false
var SkipIntro = false
var ShowDebug = false
		
func _draw():
	if ShowDebug:
		draw_line(Vector2(0, 0), -$Sprite.transform.y * 30, Color.red)

func _process(delta):
	if ShowDebug:
		update()
	
	if DetermineEntranceDistance() && !SkipIntro:
		EnterView(delta)
	else:
		if !FinishedSpawn: 
			FinishedSpawn = true
			
		if Cam != null:
			Cam.Target = self
			
		var mousePos = get_global_mouse_position()
		LookAtMouse(mousePos, delta)
		FollowMouse(mousePos, delta)
		PositionShadow()
		DrawTrail()

func EnterView(delta):
	position = Vector2(position.x, lerp(position.y, (ViewportSize.y / 2) - BottomOffset, delta * EntranceSpeed))

func DetermineEntranceDistance():
	return position.y > ((ViewportSize.y / 2) - BottomOffset) + 1 && !FinishedSpawn

func FollowMouse(point, delta):
	position += transform.x * delta * Speed

func LookAtMouse(point, delta):
	var dir = point - global_position
	var angle = atan2(dir.y, dir.x)
	rotation = lerp_angle(rotation, angle, delta * TurnSpeed)
	
func PositionShadow():
	if $Shadow != null:
		$Shadow.position = Vector2(ShadowDistance / 2 * transform.y.y, ShadowDistance * transform.x.x)

func DrawTrail():
	pass

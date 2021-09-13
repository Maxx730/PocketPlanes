extends KinematicBody2D

onready var ViewportSize = get_viewport().size

export(int) var EntranceSpeed = 1
export(int) var BottomOffset = 50
export(int) var ShadowDistance = 20
export(int) var MaxSpeed = 200
export(int) var MinSpeed = 50
export(int) var TurnSpeed = 1
export(int) var Acceleration = 5
export(int) var Fuel = 100
export(int) var Efficiency = 3

var Cam = null
var FinishedSpawn = false
var SkipIntro = false
var ShowDebug = false
var Speed = 100
var NewSpeed = 100
var CurrentFuel = Fuel
		
func _draw():
	if ShowDebug:
		draw_line(Vector2(0, 0), -$Sprite.transform.y * 30, Color.red)

func _process(delta):
	if ShowDebug:
		update()
	
	Speed = lerp(Speed, NewSpeed, delta * 10)
	
	if DetermineEntranceDistance() && !SkipIntro:
		EnterView(delta)
	else:
		if !FinishedSpawn: 
			FinishedSpawn = true
			
		if Cam != null:
			Cam.Target = self
			
		var mousePos = get_global_mouse_position()
		if DepleteFuel(Efficiency * (Speed / MaxSpeed) * delta):
			LookAtMouse(mousePos, delta)
		else:
			pass
		
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

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				NewSpeed = clamp(Speed + Acceleration, MinSpeed, MaxSpeed)
			
			if event.button_index == BUTTON_WHEEL_DOWN:
				NewSpeed = clamp(Speed - Acceleration, MinSpeed, MaxSpeed)

func DepleteFuel(amount):
	if CurrentFuel - amount < 0:
		CurrentFuel = 0
		return false
	else:
		CurrentFuel -= amount
		return true

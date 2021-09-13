extends Node2D

onready var ViewportSize = get_viewport().size

export(PackedScene) var PlayerPlane
export(NodePath) var CameraPath
export(int) var BottomMargin = 25
export(bool) var SkipIntro = false
export(bool) var ShowDebug = false

#UI Elements
export(NodePath) var SpeedPath
export(NodePath) var FuelAmount

#Debug Elements
export(NodePath) var DebugUIPath

var SpawnPoint = Vector2(0, 0)
var Spawned = false
var Cam = null
var DebugLabel = null
var Speedometer = null
var Fuel = null
var Spawn = null

func _ready():
	if CameraPath != null:
		Cam = get_node(CameraPath)
		
	SpawnPlayer(DetermineStartPoint())
	
	if DebugUIPath != null:
		DebugLabel = get_node(DebugUIPath)
		
	if SpeedPath != null:
		Speedometer = get_node(SpeedPath)
		
	if FuelAmount != null:
		Fuel = get_node(FuelAmount)

func _process(delta):
	if DebugLabel != null:
		DebugLabel.text = "FPS: " + String(Engine.get_frames_per_second())
		
	UpdateUI()
	
func SpawnPlayer(point):
	if PlayerPlane != null:
		Spawn = PlayerPlane.instance()
		Spawn.position = to_local(point)
		Spawn.Cam = Cam
		Spawn.SkipIntro = SkipIntro
		Spawn.ShowDebug = ShowDebug
		add_child(Spawn)
		
func DetermineStartPoint():
	var ViewportSize = get_viewport().size
	return Vector2(0, 0) if SkipIntro else Vector2(ViewportSize.x / 4, ViewportSize.y)

func UpdateUI():
	if Speedometer != null && Spawn != null:
		Speedometer.text = String(floor(Spawn.Speed))
		
	if Fuel != null:
		Fuel.value = 100 * (Spawn.CurrentFuel / Spawn.Fuel)

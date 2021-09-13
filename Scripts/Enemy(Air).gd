extends KinematicBody2D

enum STATE {CIRCLING, WANDERING, CHASING}

signal OnDestroyed(plane)

export(int) var Hitpoints = 100
export(float) var DamageTimeout = 0.025
export(int) var TurnRadius = 1
export(int) var CirclingSpeed = 200
export(PackedScene) var FloatingTextScene

onready var OffscreenArrowInst = preload("res://Scenes/OffscreenArrow.tscn")
onready var ExplosionInst = preload("res://Scenes/Explosion.tscn")

var DamageStart = 0.1
var State = STATE.CIRCLING
var WanderPoint = null
var Offscreen = null
var Target = null

func _draw():
	draw_line(Vector2(0, 0), -transform.y * 30, Color.red)

func _ready():
	if OffscreenArrowInst != null:
		Offscreen = OffscreenArrowInst.instance()
		Offscreen.Target = self
		get_parent().call_deferred("add_child", Offscreen)

func _physics_process(delta):
	HandleDamageFlash(delta)
	
	match State:
		STATE.WANDERING:
			if WanderPoint == null:
				RandomPoint(50)
		STATE.CIRCLING:
			MoveInCircle(delta)
		STATE.CHASING:
			LookAtTarget(delta)
			MoveForward(delta)
	
func Damage(amount):
	$Sprite.modulate = Color.red
	DamageStart = 0
	if Hitpoints - amount < 0:
		if Offscreen != null:
			Offscreen.queue_free()
		
		if ExplosionInst != null:
			var explosion = ExplosionInst.instance()
			get_parent().add_child(explosion)
			explosion.position = global_position
			explosion.get_child(2).restart()
			explosion.get_child(1).restart()
			explosion.get_child(0).rotation = atan2(-transform.x.y, -transform.x.x) - 90\
		
		if FloatingTextScene != null:
			var FloatingText = FloatingTextScene.instance()
			FloatingText.position = global_position
			get_tree().root.add_child(FloatingText)
		
		emit_signal("OnDestroyed", self)
		queue_free()
	else:
		Hitpoints -= amount
		if Hitpoints < 40:
			$EngineSmoke.visible = true

func HandleDamageFlash(delta):
	if DamageStart > DamageTimeout:
		$Sprite.modulate = Color.white
	else:
		DamageStart += delta

func RandomPoint(radius):
	pass

func MoveInCircle(delta):
	rotation += 1 * delta * TurnRadius
	position += -transform.y * delta * CirclingSpeed

func OnTargetEntered(body):
	if body.is_in_group("Plane"):
		Target = body
		State = STATE.CHASING

func LookAtTarget(delta):
	var dir = Target.global_position - global_position
	var angle = atan2(dir.y, dir.x)
	rotation = lerp_angle(rotation, rotation + angle, delta)
	
func MoveForward(delta):
	position += -transform.y * delta * CirclingSpeed

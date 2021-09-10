extends Node2D

export(PackedScene) var Weapon1
export(PackedScene) var Weapon2
export(NodePath) var MuzzleOneInst
export(NodePath) var MuzzleTwoInst

var WeaponOneRate = 0
var WeaponTwoRate = 0
var WeaponOneLastShot = 0
var WeaponTwoLastShot = 0
var MuzzleOne = null
var MuzzleTwo = null

func _ready():
	GetWeapons()

func _process(delta):
	if Input.is_action_pressed("fire"):
		FireWeapons(delta)

func FireWeapons(delta):
	if Weapon1 != null:
		if WeaponOneLastShot > WeaponOneRate:
			FireShot(Weapon1, $Weapon1.position, $Weapon1.global_transform)
			WeaponOneLastShot = 0
			if MuzzleOne != null:
				MuzzleOne.restart()
		else:
			WeaponOneLastShot += delta
	
	if Weapon2 != null:
		if WeaponTwoLastShot > WeaponTwoRate:
			FireShot(Weapon2, $Weapon2.position, $Weapon2.global_transform)
			WeaponTwoLastShot = 0
			if MuzzleTwo != null:
				MuzzleTwo.restart()
		else:
			WeaponTwoLastShot += delta

func FireShot(weapon, point, transform):
	var shot = weapon.instance()
	shot.position = to_global(point)
	shot.transform = transform
	shot.apply_central_impulse(shot.transform.x * shot.FireSpeed)
	get_tree().root.add_child(shot)

func GetWeapons():
	if Weapon1 != null:
		var weap = Weapon1.instance()
		WeaponOneRate = weap.FireRate
		weap.queue_free()
		
	if Weapon2 != null:
		var weap = Weapon2.instance()
		WeaponTwoRate = weap.FireRate
		weap.queue_free()
		
	if MuzzleOneInst != null:
		MuzzleOne = get_node(MuzzleOneInst)
		
	if MuzzleTwoInst != null:
		MuzzleTwo = get_node(MuzzleTwoInst)

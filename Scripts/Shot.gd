extends RigidBody2D

export(float) var FireRate = 0.15
export(float) var FireSpeed = 1500
export(PackedScene) var ImpactScene
export(int) var Damage = 5

func _process(delta):
	update()

func OnShotExited():
	queue_free()

func ShotCollided(body):
	if ImpactScene != null:
		var impact = ImpactScene.instance()
		impact.position = global_position
		get_tree().root.add_child(impact)
		impact.restart()
		
		if body.has_method("Damage"):
			body.Damage(Damage)
	queue_free()

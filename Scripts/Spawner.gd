extends Node2D

export(PackedScene) var SpawnItem
export(int) var SpawnPerSeconds = 1
export(bool) var Infinate = false
export(int) var Amount = 0
export(int) var MaxSpawned = 10

var Spawned = Array()

var LastSpawn = 0

func _process(delta):
	if Spawned.size() < MaxSpawned:
		if LastSpawn > SpawnPerSeconds:
			Spawn()
			LastSpawn = 0
		else:
			LastSpawn += delta
	else:
		LastSpawn = 0

func Spawn():
	if SpawnItem != null and (Infinate || Amount > 0):
		var item = SpawnItem.instance()
		Spawned.append(item)
		get_parent().add_child(item)
		item.connect("OnDestroyed", self, "SpawnDestroyed")
		if !Infinate:
			Amount -= 1

func SpawnDestroyed(spawn):
	if Spawned.has(spawn):
		var index = Spawned.find(spawn, 0)
		Spawned.remove(index)
		

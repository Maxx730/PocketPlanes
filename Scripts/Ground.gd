extends TileMap

export(int) var Width = 50
export(int) var Height = 50

onready var RNG = RandomNumberGenerator.new()
onready var Noise = OpenSimplexNoise.new()

func _ready():
	RNG.randomize()
	Noise.seed = RNG.randi()
	Noise.octaves = 4
	Noise.period = 20.0
	Noise.persistence = 0.8
	
	GenerateMap()

func GenerateMap():
	for x in Width:
		for y in Height:
			var val = GetTile(Noise.get_noise_2d(x, y))
			set_cell(x, y, val)

func GetTile(val):
	if val > 0.05:
		return 4
	else:
		return 5

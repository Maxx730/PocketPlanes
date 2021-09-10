extends Line2D

func _ready():
	set_as_toplevel(true)

func _process(delta):
	var parent = get_parent().get_parent()
	add_point(get_parent().global_position)
	
	var Cutoff = 25
	if "Speed" in parent and parent.Speed != null and parent.MaxSpeed != null:
		Cutoff = Cutoff * parent.Speed / parent.MaxSpeed
		
	if get_point_count() > Cutoff:
		remove_point(0)

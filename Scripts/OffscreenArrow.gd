extends Node2D

var Target = null

func _ready():
	if Target != null:
		self.transform.origin = Target.transform.origin

func _process(delta):
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
		
	AlignArrow(Rect2(top_left, size))
	RotateArrow()	

func AlignArrow(bounds : Rect2):
	if Target != null:
		$Sprite.global_position.x = clamp(Target.global_position.x, bounds.position.x, bounds.end.x)
		$Sprite.global_position.y = clamp(Target.global_position.y, bounds.position.y, bounds.end.y)
	
	if (bounds.has_point(Target.global_position)):
		hide()
	else:
		show()

func RotateArrow():
	var angle = (global_position - $Sprite.global_position).angle()
	$Sprite.rotation = angle
	$Sprite.rotation_degrees -= 90

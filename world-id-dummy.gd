extends CSGBox

export var color = Color() setget set_color

func set_color(col):
	material_override.albedo_color = col

func _ready():
	pass # Replace with function body.



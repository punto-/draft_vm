extends "world_object.gd"

export var color = Color() setget set_color

func set_color(col):
	self.material_override.albedo_color = col

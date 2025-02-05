extends Node2D

onready var vm = get_node("/root/vm")

func _ready():

	print("main!")

	var code = vm.load_code(preload("test_code.gd").move_cube)
	vm.start_task(code.duplicate())
	

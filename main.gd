extends Node2D

onready var vm = get_node("/root/vm")

func _ready():

	print("main!")

	var move_code = vm.load_code(preload("test_code.gd").move_cube)
	vm.start_task(move_code.duplicate())

	var color_code = vm.load_code(preload("test_code.gd").color_cube)
	vm.start_task(color_code.duplicate())
	
	var input_code = vm.load_code(preload("test_code.gd").take_input)
	vm.start_task(input_code.duplicate())

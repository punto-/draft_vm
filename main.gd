extends Node2D

onready var vm = get_node("/root/vm")

func _ready():

	print("main!")

	var input_code = vm.load_code(preload("test_code.gd").main)
	vm.start_task(input_code.duplicate())

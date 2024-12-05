extends Node2D

onready var vm = get_node("/root/vm")

func _ready():

	print("main!")
	vm.set_global("cond_2", true) # bit of cheating for branch test

	var code = get_node("code")
	vm.start_task(code)
	

extends Node

onready var vm = get_node("/root/vm")

func execute(context):
	return vm.RET_RETURN

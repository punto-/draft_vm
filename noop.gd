extends Node

onready var vm = get_node("/root/vm")

export var params = []

export var break_guard = false

func execute(context):
	return vm.RET_RETURN

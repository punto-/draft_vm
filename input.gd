extends "noop.gd"

export var global = ""

func input(val, top):
	printt("got input ", global, val)
	vm.set_global(global, val)
	vm.resume(top)

func execute(context):
	var ui = get_node("/root/ui")
	ui.get_input(self, "input", context.call_stack.back())
	return vm.RET_YIELD



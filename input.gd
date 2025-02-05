extends "noop.gd"

func input(val, context):
	printt("got input ", val)
	context.stack.push_back(val)
	vm.resume(context.call_stack.back())

func execute(context):
	var ui = get_node("/root/ui")
	ui.get_input(self, "input", context)
	return vm.RET_YIELD



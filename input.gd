extends "noop.gd"

func input(val, context):
	context.stack.push_back(val)
	vm.resume(context.call_stack.back())

func execute(context):
	var ui = get_node("/root/ui")
	var title = ""
	if params.size() > 0:
		title = vm.opr.get_value(context, params[0])

	ui.get_input(self, "input", context, title)
	return vm.RET_YIELD



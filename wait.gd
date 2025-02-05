extends "noop.gd"

func timeout(top):
	vm.resume(top)

func execute(context):

	var top = context.call_stack.back()

	var time = vm.opr.get_value(context, params[0])

	# the vm provides timers because it's easier than putting a timer node on the scene
	vm.add_timer(self, top, time)

	return vm.RET_YIELD


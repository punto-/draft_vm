extends "noop.gd"

export var time = 1.0

func timeout(top):
	vm.resume(top)

func execute(context):

	var top = context.call_stack.back()

	# the vm provides timers because it's easier than putting a timer node on the scene
	vm.add_timer(self, top, time)

	return vm.RET_YIELD


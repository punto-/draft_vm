extends "noop.gd"

export var count = 0
export var count_global = ""

func execute(context):

	var top = context.call_stack.back()
	var n = count
	if count_global != "":
		n = int(vm.get_global(count_global))

	if top.sequence >= n:
		return vm.RET_RETURN

	printt("repeat count is ", n, top.sequence)

	return vm.RET_BRANCH_REPEAT

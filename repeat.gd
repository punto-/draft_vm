extends "noop.gd"

var sequence = null

func execute(context):

	var top = context.call_stack.back()
	var n = int(vm.opr.get_value(context, params[0]))

	if sequence == null:
		sequence = 0

	if sequence >= n:
		sequence = null
		return vm.RET_RETURN

	printt("repeat count is ", n, sequence)
	sequence += 1

	return vm.RET_BRANCH_REPEAT

func _ready():
	break_guard = true

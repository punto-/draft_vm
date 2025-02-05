extends "noop.gd"

func execute(context):

	var cond = true
	if params.size() > 0:
		cond = vm.opr.get_value(params[0])

	if !cond:
		return vm.RET_RETURN

	return vm.RET_REPEAT

extends "noop.gd"

func execute(context):

	print(str(vm.opr.get_value(context, params[0])))

	return vm.RET_RETURN


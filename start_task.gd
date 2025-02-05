extends "noop.gd"

func execute(context):

	var obj = vm.opr.get_value(context, params[0])
	var event = vm.opr.get_value(context, params[1])

	if !(event in obj.events):
		# error! event not found
		print("error! event ", event, "not found in object ", str(obj), obj.get_path())
		return vm.RET_RETURN

	var code = obj.get_event_code(event)
	vm.start_task(code, { "self": obj })

	return vm.RET_RETURN

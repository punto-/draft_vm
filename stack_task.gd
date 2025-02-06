extends "noop.gd"

var code_cache

func unload():
	if code_cache == null:
		return
		
	code_cache.queue_free()
	code_cache = null

func execute(context):
	
	var obj = vm.opr.get_value(context, params[0])
	var event = vm.opr.get_value(context, params[1])

	if obj == null:
		# error! event not found
		print("error! is null")
		return vm.RET_RETURN

	var code = obj.get_event_code(event)
	
	if code == null:
		# error! event not found
		print("error! event ", event, "not found in object ", str(obj), obj.get_path())
		return vm.RET_RETURN
	
	code_cache = code
	add_child(code)

	return vm.RET_BRANCH
	

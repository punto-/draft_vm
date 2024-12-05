extends "noop.gd"

export var literal = ""
export var global_var = ""

func execute(context):
	if global_var != "":
		print(vm.get_global(global_var))
	else:
		print(literal)



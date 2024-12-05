extends "noop.gd"

const CHAIN_NONE = 0
const CHAIN_START = 1
const CHAIN_MIDDLE = 2
const CHAIN_END = 3

export(int, "None", "Start", "Middle", "End") var chain_pos = 0

export var condition = ""

func execute(context):

	var run = true
	if chain_pos > CHAIN_START: # middle or end, check if previous branches already ran
		run = !context.stack.back()

	if !run:
		if chain_pos == CHAIN_END:
			context.stack.pop_back()
		return

	run = vm.get_global(condition)

	if chain_pos == CHAIN_START:
		context.stack.push_back(run)
	elif chain_pos == CHAIN_MIDDLE:
		context.stack[context.stack.size()-1] = run
	elif chain_pos == CHAIN_END:
		context.stack.pop_back()

	if run:
		return vm.RET_BRANCH
	else:
		return vm.RET_RETURN




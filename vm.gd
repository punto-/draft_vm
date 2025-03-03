extends Node

var tasks = []
var timers = []

var globals = {}

const RET_RETURN = 0
const RET_BRANCH = 1
const RET_BRANCH_REPEAT = 2
const RET_BREAK = 3
const RET_REPEAT = 4
const RET_YIELD = 5

var opr

var instructions = {

	"noop": preload("noop.gd"),
	"wait": preload("wait.gd"),
	"input": preload("input.gd"),
	"branch": load("branch.gd"),
	"interpolate": preload("interpolate.gd"),
	"loop": preload("loop.gd"),
	"print": preload("print.gd"),
	"repeat": preload("repeat.gd"),
	"root_branch": load("root_branch.gd"),
	"start_task": preload("start_task.gd"),
	"stack_task": preload("stack_task.gd"),
}

var task_nodes

####### some helpers

# we put timers here to avoid using timer nodes (because I don't know where the scene is :p ) or doing a "busy wait" in the time.gd script

func add_timer(node, udata, time):
	timers.push_back([node, udata, time])

func check_timers(time):
	var i = timers.size()

	while i:
		i -= 1
		timers[i][2] -= time
		if timers[i][2] <= 0:
			timers[i][0].timeout(timers[i][1])
			timers.remove(i)

func set_global(name, val):
	globals[name] = val

func get_global(name):
	if !(name in globals):
		return null

	return globals[name]

func get_object(name):

	return get_node("/root/main/world-objects/"+name)

func find_scope_var(context, name):
	var i = context.call_stack.size()
	while i:
		i -= 1
		if name in context.call_stack[i].scope_vars:
			return i

	return null

func get_scope_var(context, level, name):

	if level == null || level >= context.call_stack.size():
		return null

	if level < 0:
		level = context.call_stack.size() - level

		if level < 0:
			return null

	if !(name in context.call_stack[level].scope_vars):
		return null

	return context.call_stack[level].scope_vars[name]

func set_scope_var(context, level, name, val):

	if level == null || level >= context.call_stack.size():
		return null

	if level < 0:
		level = context.call_stack.size() - level

		if level < 0:
			return null

	context.call_stack[level].scope_vars[name] = val

func resume(frame):
	frame.suspended = false

func _stack_level(parent, top, vars = {}):
	return { "ip": 0, "parent": parent, "value_top": top, "suspended": false, "scope_vars": vars }

func start_task(code, vars = {}):
	
	var context = { "stack": [], "call_stack": [], "root": code }
	context.call_stack.push_back( _stack_level(code, context.stack.size(), vars) )
	
	tasks.push_back(context)
	task_nodes.add_child(code)

func load_code(root):

	var root_branch = Node.new()
	root_branch.set_script(instructions["root_branch"])
	_load_code_level(root_branch, root)

	return root_branch

func _load_code_level(parent, code):
	for i in code:
		if !(i[0] in instructions):
			# error! invalid instruction
			continue
		var n = Node.new()
		var s = instructions[i[0]]
		n.set_script(s)
		if i.size() > 1:
			n.params = i[1]
		if i.size() > 2:
			_load_code_level(n, i[2])
		parent.add_child(n)

func run(context):

	var top = context.call_stack.back()
	if top.suspended:
		return RET_YIELD

	while top.ip < top.parent.get_child_count() && !top.suspended:
		var node = top.parent.get_child(top.ip)
		var ret = node.execute(context)

		if ret == null:
			ret = RET_RETURN

		if ret == RET_RETURN:
			top.ip += 1
			continue

		if ret == RET_BRANCH:
			top.ip += 1
			context.call_stack.push_back( _stack_level(node, context.stack.size()) )
			return ret

		if ret == RET_BRANCH_REPEAT:
			# but not increasing top.ip, when the new stack level finishes execution it will run this instruction again
			context.call_stack.push_back( _stack_level(node, context.stack.size()) )
			return ret

		if ret == RET_REPEAT:
			top.ip = 0
			continue

		if ret == RET_BREAK:
			var i = context.call_stack.size()
			while i:
				i -= 1
				if context.call_stack[i].node.break_guard:
					_pop_stack(context, i-1)
					break
			if i == 0:
				_pop_stack(context, 0)

			return RET_RETURN

		if ret == RET_YIELD:
			top.suspended = true
			top.ip += 1
			return ret

	# level is done, pop the stack
	_pop_stack(context, context.call_stack.size()-1)

	return RET_RETURN

# pop the call stack to level n. 0 leaves it empty
# also pops the value stack to the level it was when the level was top
func _pop_stack(context, n):

	var l = context.call_stack.size()

	if l <= n:
		return

	while l > n:
		l -= 1
		context.call_stack[l].parent.unload()

	# not sure if this is necessary, some blocks of code might return stuff in the stack?
	#if n > 0:
	#	context.stack.resize(context.call_stack[n].value_top)

	context.call_stack.resize(n)


func _process(time):

	check_timers(time)

	for t in tasks:
		while t.call_stack.size():
			var ret = run(t)
			if ret == RET_YIELD:
				break

	var t = tasks.size()
	while t:
		t -= 1
		if tasks[t].call_stack.size() > 0:
			continue
			
		# task finished
		var task = tasks[t]
		tasks.remove(t)
		
		finish_task(task)

func finish_task(task):
	task.root.queue_free()

func _ready():
	task_nodes = get_node("task_nodes")
	opr = preload("operator.gd").new()
	opr.vm = self
	set_process(true)

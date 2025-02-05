var vm

### operator types

var type_handlers = {

	"l": "get_literal",
	"s": "get_stack",
	"sv": "get_scope_var",
	"gv": "get_global_var",
	"o": "get_object",

	"sp": "stack_push",

	"gt": "compare",
	"ge": "compare",
	"eq": "compare",
	"ne": "compare",
	"lt": "compare",
	"le": "compare",

	"or": "gate",
	"and": "gate",
	"not": "negate",

	"obj_i": "object_index",
	"arr_i": "array_index",
}

func get_value(context, opr):
	if !(opr is Array):
		return opr
	
	var type = opr[0]
	if !(type in type_handlers):
		return null

	return call(type_handlers[type], context, opr)


func get_literal(context, opr):
	return opr[1]

func get_stack(context, opr):

	var pos = get_value(context, opr[1])
	if typeof(pos) != TYPE_INT:
		return null
	if pos < 0:
		pos = context.stack.size() + pos

	if pos < 0 || pos >= context.stack.size():
		return null

	var pop = false
	if opr.size() > 2:
		pop = get_value(context, opr[2])

	var ret = context.stack[pos]
	if pop:
		context.stack.remove(pos)
	return ret

func stack_push(context, opr):
	var val = get_value(context, opr[1])
	context.stack.push_back(val)
	return val

func get_scope_var(context, opr):

	var name = get_value(context, opr[1])
	if typeof(name) != TYPE_STRING:
		return null

	var csl = vm.find_scope_var(context, name)
	if csl == null:
		return null
	return context.call_stack[csl].scope_vars[name]

func get_global_var(context, opr):

	var name = get_value(context, opr[1])
	return vm.get_global(name)

func get_object(context, opr):

	var name = get_value(context, opr[1])
	return vm.get_object(name)

func compare(context, opr):

	if opr.size() < 3:
		return null

	var val1 = get_value(context, opr[1])
	var val2 = get_value(context, opr[2])

	match opr[0]:
		"gt":
			return val1 > val2
		"ge":
			return val1 >= val2
		"eq":
			return val1 == val2
		"ne":
			return val1 != val2
		"lt":
			return val1 < val2
		"le":
			return val1 <= val2

	return null

func negate(context, opr):
	return !get_value(context, opr[1])

func gate(context, opr):
	if opr.size() != 3:
		return null

	var v1 = get_value(context, opr[1])
	var v2 = get_value(context, opr[2])
	
	match opr[0]:
		"or":
			return v1 or v2
		"and":
			return v1 and v2

func array_index(context, opr):
	
	var arr = get_value(context, opr[1])
	var i = get_value(context, opr[2])

	if typeof(arr) != TYPE_ARRAY:
		return null

	return arr[i]

func object_index(context, opr):

	var obj = get_value(context, opr[1])
	var name = get_value(context, opr[2])

	if !(name in obj):
		return null
	
	return obj.get(name)

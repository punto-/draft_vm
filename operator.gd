var vm

### operator types

var type_handlers = {

	"l": "get_literal",
	"s": "get_stack",
	"sv": "get_scope_var",
	"gv": "get_global_var",

	"gt": "compare",
	"ge": "compare",
	"eq": "compare",
	"lt": "compare",
	"le": "compare",
	
	"arr_i": "array_index",
}

func get_value(context, opr):
	if !(opr is Array):
		return opr
	
	var type = opr[0]
	if !(type in type_handlers):
		return null


func get_literal(context, opr):
	return opr[1]

func get_stack(context, opr):

	var pos = get_value(context, opr[1])
	if typeof(pos) != TYPE_INT:
		return null
	if pos < 0:
		pos = context.stack.size() - pos

	if pos < 0 || pos >= context.stack.size():
		return null

	return context.stack[pos]

func get_scope_var(context, opr):

	var name = get_value(context, opr[1])
	if typeof(name) != TYPE_STRING:
		return null

	var csl = vm.find_scope_var(context, name)
	return context.call_stack[csl].scope_vars[name]

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
		"lt":
			return val1 < val2
		"le":
			return val1 <= val2

	return null

func array_index(context, opr):
	
	var arr = opr[1]
	var i = opr[2]

	if typeof(arr) != TYPE_ARRAY:
		return null

	return arr[i]

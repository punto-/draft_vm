extends "noop.gd"

# params requires object, property, initial value, end value, time

var tween
var top

func tween_finished():
	vm.resume(top)
	tween = null
	top = null

func execute(context):

	top = context.call_stack.back()

	var object = vm.opr.get_value(context, params[0])
	var property = vm.opr.get_value(context, params[1])
	var v1 = vm.opr.get_value(context, params[2])
	var v2 = vm.opr.get_value(context, params[3])
	var time = vm.opr.get_value(context, params[4])

	tween = create_tween()
	tween.tween_property(object, property, v2, time).from(v1)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(self, "tween_finished")

	return vm.RET_YIELD


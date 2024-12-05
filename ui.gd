extends Control

var slot
var slot_method
var slot_udata

func get_input(obj, method, udata):

	slot = obj
	slot_method = method
	slot_udata = udata

	show()

func done():

	var val = get_node("text").get_text()
	if slot:
		slot.call(slot_method, val, slot_udata)

	slot = null
	hide()


func _ready():

	hide()
	get_node("button").connect("pressed", self, "done")

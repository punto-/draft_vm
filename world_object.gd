extends Node

var vm

export var events: Script

var event_code = {}

func get_event_code(name):
	if !(name in events):
		return null
	
	if !(name in event_code):
		var code = vm.load_code(events[name])
		if !code:
			return null
		event_code[name] = code

	return event_code[name].duplicate()

func _ready():
	vm = get_node("/root/vm")

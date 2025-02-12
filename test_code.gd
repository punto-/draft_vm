
const main = [
	
	["stack_task", [ ["o", "world-id-dummy"], "take_input" ] ],
	["print", ["Call finished!"]],
]


const take_input = [

	["input", ["Enter task name ('transform', 'color' or 'both')"]],
	["branch", [ ["or", ["eq", ["s", -1], "transform" ], ["eq", ["s", -1], "both" ] ], 0 ], [
	
		["start_task", [ ["sv", "self"], "move_cube"] ],
		["print", ["started task move"]],
		
	]],
	["branch", [ ["or", ["eq", ["s", -1], "color" ], ["eq", ["s", -1], "both" ] ], 0 ], [
	
		["start_task", [ ["o", "world-id-dummy"], "color_cube"] ],
		["print", ["started task color"]],
		
	]],
]

const move_cube = [
	
	["branch", ["true", 0], [
		
		["interpolate", [
			["o", "world-id-dummy"],
			"transform",
			["sp", ["obj_i", ["o", "world-id-dummy"], "transform" ]], # stack push world-id-dummy.transform
			Transform.IDENTITY,
			5, # seconds
		]],
		["interpolate", [
			["o", "world-id-dummy"],
			"transform",
			Transform.IDENTITY,
			["s", -1, true], # pop from stack the value pushed before
			5, # seconds
		]],
		["loop"]
		
	]],
]

const color_cube = [

	["interpolate", [ ["o", "world-id-dummy"], "color", Color.red, Color.green, 2] ],
	["interpolate", [ ["o", "world-id-dummy"], "color", Color.green, Color.blue, 2] ],
	["interpolate", [ ["o", "world-id-dummy"], "color", Color.blue, Color.red, 2] ],
	["loop"]
]


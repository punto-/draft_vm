
const take_input = [

	["input"],
	["repeat", [["s", -1]], [

		["print", ["looping!"]],
		["wait", [1]],
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


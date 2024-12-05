# A draft VM for running high level code.

## Running the example

Run the main scene, the "code" is in the scene `code.tscn`, consists of the following steps:

- An input request from the user. You can input a number here
- A repeat loop that repets for the number of times input in the previous step
  - An instruction that prints "Repeat loop!" to the console
  - A 1 second wait
- A chain of 3 branches that check for global values `cond_1`, `cond_2` and `cond_1` again (`cond_2` is set to true in `main.gd`), each branch prints to the console.

## Implementation details

### The Virtual Machine (VM)

The basic structure of the VM consists of a list of tasks. Each task is an execution "thread", multiple tasks can exist at the same time, but they are executed sequentially, once per frame the VM
run loop iterates over all tasks, each task will run until completion, or until it suspends its execution (due to waiting for an external process to finish, like an
animation, user input, a timer, etc), at this point control goes back to the VM to run the next task.

Within each task, there's a `call_stack`, with multiple levels. Each level represents a flat list of instructions, that can branch into a new level. Example:

``` gdscript
print "this is level 0"
npc_move(position)

if player_has_key:
  # this is level 1
  open_door()

# back on level 0
play_video(room)
```

In the task there is also a value stack, with values that can be pushed and popped by the different instructions. This is used for internal implementation.

Each level in the execution stack has the following elements:

- `ip` the instruction pointer, this is the current instruction that is being executed in the current level
- `parent` the parent level
- `value_top` the current top of the value stack at this level of execution
- `suspended` whether the execution is suspended for this level (might need to be moved to the task
- `sequence` indicates the number of loops that are running on a looping stack level
- `scope_vars` a dictionary with name/values that belong to the current levels. Can be accessed by the current level and the levels below it

### The Code

The code is implemented as a scene tree, each node is one instruction. All instructions have to inherit the `noop.gd` script, that has 1 method, `execute(context)`.

The `execute` method can return one of the values defined in `vm.gd`:

- `RET_RETURN` indicates that the instruction is done executing
- `RET_BRANCH` and `RET_BRANCH_REPEAT` indicates that the instruction will add a new level to the call stack (see `branch.gd` or `repeat.gd`)
- `RET_BREAK` causes the VM to break out of the current execution level, until a break guard is found
- `RET_REPEAT` causes the VM to jump back to the begnning of the current execution level
- `RET_YIELD` indicates that the instruction is not done executing, and returns control back to the VM. This leaves the task suspended until
   it becomes unsuspended (it's the responsibility of the instruction to unsuspend the task). See `wait.gd` and `input.gd` for an example.


### Current features:

This repository is proof of concept, but includes some instructions to test the features of the VM:

- `branch.gd` used for branching based on conditions (if/then/else type structures). Creates a new level on the call stack when a branch runs
- `input.gd` used to get input from the user. Suspends the task until input is entered
- `print.gd` prints to the console
- `repeat.gd` repeats a block of code on a loop
- `wait.gd` waits an amount of time while the task is suspended

### Missing features

Some features need testing:

- using the `break` instruction
- using scope variables

Some features need development (all possible to implement with the current VM):

- an operator/temporary value system
- function calls





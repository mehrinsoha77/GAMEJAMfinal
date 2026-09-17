extends Node
## Tracks which Degrees of Freedom the player currently has.
## Confirmed progression (per the reconciled level table):
##   Level 1 (Corridor)     -> unlocks "backward"
##   Level 2 (Engine Room)  -> unlocks "turn"
##   Level 3 (Cargo Bay)    -> unlocks "strafe"
##   Level 4 (Command Deck) -> unlocks "jump"
## PlayerController reads these flags every physics frame; it never
## hardcodes level-specific logic itself.

var can_move_forward: bool = true
var can_move_backward: bool = false
var can_turn: bool = false
var can_strafe: bool = false
var can_jump: bool = false

const VALID_DOFS := ["backward", "turn", "strafe", "jump"]

func unlock(dof_name: String) -> void:
	if not VALID_DOFS.has(dof_name):
		push_warning("DOFManager.unlock() called with unknown dof '%s'" % dof_name)
		return
	match dof_name:
		"backward":
			if can_move_backward:
				return
			can_move_backward = true
		"turn":
			if can_turn:
				return
			can_turn = true
		"strafe":
			if can_strafe:
				return
			can_strafe = true
		"jump":
			if can_jump:
				return
			can_jump = true
	EventBus.dof_unlocked.emit(dof_name)

func is_unlocked(dof_name: String) -> bool:
	match dof_name:
		"forward":
			return can_move_forward
		"backward":
			return can_move_backward
		"turn":
			return can_turn
		"strafe":
			return can_strafe
		"jump":
			return can_jump
	return false

## Call when returning to main menu / restarting a save so DOF state
## doesn't leak between playthroughs.
func reset() -> void:
	can_move_forward = true
	can_move_backward = false
	can_turn = false
	can_strafe = false
	can_jump = false

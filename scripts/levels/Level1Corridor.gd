extends Node3D
## Level 1 only wires events together. It holds no puzzle logic and no
## audio-file logic itself - that's all in the shared systems - so this
## is the template every later level's controller script should follow.

@export var puzzle_id_for_this_level: String = "brs_trivia"
@export var dof_this_level_unlocks: String = "backward"

@onready var door: Node3D = $Door
@onready var exit_area: Area3D = $ExitArea

func _ready() -> void:
	EventBus.puzzle_completed.connect(_on_puzzle_completed)
	exit_area.body_entered.connect(_on_exit_entered)
	AudioManager.play_music("level1_theme")

func _on_puzzle_completed(puzzle_id: String) -> void:
	if puzzle_id != puzzle_id_for_this_level:
		return
	DOFManager.unlock(dof_this_level_unlocks)
	UIManager.show_banner("DEGREE OF FREEDOM UNLOCKED\nBACKWARD MOVEMENT AVAILABLE", 3.0)
	AudioManager.play_sfx("dof_unlock")
	door.unlock()

func _on_exit_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	UIManager.show_banner("LEVEL 1 COMPLETE", 2.0)
	AudioManager.play_sfx("level_complete")
	EventBus.level_completed.emit("level_1")

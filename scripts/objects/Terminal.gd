extends Area3D
## Shared terminal: any level's puzzle (trivia, color-connect, sliding
## tiles, ...) plugs in here via the exported puzzle_scene + puzzle_id.
## The terminal doesn't know or care which puzzle it's running - it only
## needs the puzzle's root node to emit a "puzzle_solved" signal.

@export var puzzle_id: String = ""
@export var puzzle_scene: PackedScene

var _player_in_range: bool = false
var _puzzle_instance: Node = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		UIManager.show_banner("Press E to access terminal", 1.5)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and _puzzle_instance == null and event.is_action_pressed("interact"):
		_open_puzzle()

func _open_puzzle() -> void:
	if puzzle_scene == null:
		push_warning("Terminal '%s' has no puzzle_scene assigned." % puzzle_id)
		return
	AudioManager.play_sfx("ui_panel_open")
	_puzzle_instance = puzzle_scene.instantiate()
	get_tree().root.add_child(_puzzle_instance)
	if _puzzle_instance.has_signal("puzzle_solved"):
		_puzzle_instance.puzzle_solved.connect(_on_puzzle_solved)
	else:
		push_warning("Puzzle scene for '%s' has no 'puzzle_solved' signal." % puzzle_id)

func _on_puzzle_solved() -> void:
	AudioManager.play_sfx("puzzle_correct")
	EventBus.puzzle_completed.emit(puzzle_id)
	if is_instance_valid(_puzzle_instance):
		_puzzle_instance.queue_free()
	_puzzle_instance = null

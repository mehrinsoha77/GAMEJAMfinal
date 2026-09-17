extends Node3D
## Shared door: starts locked, plays the access-denied sfx if the player
## touches it while locked, and opens (animated if an AnimationPlayer
## named "AnimationPlayer" with an "open" clip exists, otherwise a
## simple placeholder slide-up tween so it's testable before art lands).

@export var starts_locked: bool = true

var is_locked: bool = true

func _ready() -> void:
	is_locked = starts_locked

func unlock() -> void:
	if not is_locked:
		return
	is_locked = false
	AudioManager.play_sfx("door_unlock")

	var anim := get_node_or_null("AnimationPlayer") as AnimationPlayer
	if anim and anim.has_animation("open"):
		anim.play("open")
	else:
		var tween := create_tween()
		tween.tween_property(self, "position:y", position.y + 3.0, 1.0)

## Called by the player/level when trying to pass through. Returns
## whether entry is allowed, and handles the "denied" feedback itself.
func try_enter() -> bool:
	if is_locked:
		AudioManager.play_sfx("access_denied")
		return false
	return true

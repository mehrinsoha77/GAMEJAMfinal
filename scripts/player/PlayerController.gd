extends CharacterBody3D
## Shared player controller for every level. It never checks "what level
## am I in" - it only ever asks DOFManager which axes are currently
## unlocked. That's what makes it reusable from Level 1 through Level 5
## without edits: Level 1 just happens to start with everything but
## forward/backward locked.

@export var move_speed: float = 4.0
@export var turn_speed: float = 2.2  # radians/sec
@export var jump_velocity: float = 6.0
@export var gravity: float = 18.0

func _physics_process(delta: float) -> void:
	_apply_turn(delta)
	_apply_movement(delta)
	_apply_gravity_and_jump(delta)
	move_and_slide()

func _apply_turn(delta: float) -> void:
	if not DOFManager.can_turn:
		return
	var turn_input := Input.get_axis("turn_left", "turn_right")
	if turn_input != 0.0:
		rotate_y(-turn_input * turn_speed * delta)

func _apply_movement(_delta: float) -> void:
	var input_dir := Vector2.ZERO

	if DOFManager.can_move_forward and Input.is_action_pressed("move_forward"):
		input_dir.y -= 1.0
	if DOFManager.can_move_backward and Input.is_action_pressed("move_backward"):
		input_dir.y += 1.0
	if DOFManager.can_strafe:
		if Input.is_action_pressed("strafe_left"):
			input_dir.x -= 1.0
		if Input.is_action_pressed("strafe_right"):
			input_dir.x += 1.0

	var direction := Vector3.ZERO
	if input_dir != Vector2.ZERO:
		direction = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed

func _apply_gravity_and_jump(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif DOFManager.can_jump and Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
	else:
		velocity.y = 0.0

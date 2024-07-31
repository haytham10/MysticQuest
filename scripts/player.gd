extends CharacterBody2D

const SPEED = 150.0
const CROUCH_SPEED = 75.0  # Reduced speed while crouching
const JUMP_VELOCITY = -375.0
const FALL_VELOCITY_THRESHOLD = -50.0  # Adjust this value to fit your game's needs

@onready var player_animation = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_crouching = false


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_crouching:
		velocity.y = JUMP_VELOCITY

	# Handle crouch.
	if Input.is_action_pressed("ui_down") and is_on_floor():
		is_crouching = true
	else:
		is_crouching = false

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")

	if is_crouching:
		if direction != 0:
			player_animation.play("crouch_walk")
			velocity.x = direction * CROUCH_SPEED
		else:
			player_animation.play("crouch_idle")
			velocity.x = 0  # Stop horizontal movement when idle crouching
		
		# Flip the sprite based on direction while crouching
		player_animation.flip_h = direction < 0
	else:
		if direction != 0:
			player_animation.play("run")
			velocity.x = direction * SPEED
			# Flip the sprite based on direction
			player_animation.flip_h = direction < 0
		else:
			player_animation.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Update the animation state based on the current state.
	_update_animation()

func _update_animation():
	if is_on_floor():
		if is_crouching:
			# Already handled in _physics_process
			pass
		elif velocity.x == 0:
			player_animation.play("idle")
		else:
			player_animation.play("run")
	else:
		# Determine if the player is jumping or falling
		if velocity.y < FALL_VELOCITY_THRESHOLD:
			player_animation.play("fall")
		else:
			player_animation.play("jump")

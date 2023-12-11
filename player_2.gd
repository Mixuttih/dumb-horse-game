extends CharacterBody3D

@onready var horsearse_2 = $horsearse2

var SPEED = Globals.speed_player_2
var JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	SPEED = Globals.speed_player_2
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump_2") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left_2", "right_2", "forward_2", "backward_2")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		horsearse_2.rotation.y = lerp_angle(horsearse_2.rotation.y, atan2(input_dir.x, input_dir.y), .25)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 20)
		velocity.z = move_toward(velocity.z, 0, SPEED / 20)

	move_and_slide()

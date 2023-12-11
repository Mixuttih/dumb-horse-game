extends CharacterBody3D

@onready var horseface_2 = $horseface2

var SPEED = Globals.speed_player_1
var JUMP_VELOCITY = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")



func _physics_process(delta):
	SPEED = Globals.speed_player_1
	
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		horseface_2.rotation.y = lerp_angle(horseface_2.rotation.y, atan2(input_dir.x, input_dir.y), .25)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 20)
		velocity.z = move_toward(velocity.z, 0, SPEED / 20)
		
	move_and_slide()

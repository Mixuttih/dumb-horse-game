extends Node3D

@onready var moving_platform = $moving_platform
@onready var animation_player = $moving_platform/AnimationPlayer


@onready var middle_mesh = $middle_mesh
@onready var mesh = middle_mesh.get_node("MeshInstance3D")

@onready var player_1 = $player1
@onready var player_2 = $player2
@onready var game_over_label = $GameOver



var mid_point_x
var mid_point_y
var mid_point_z
var mid_point_calc

var distance
var player_distance
var timer_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("moving")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mesh.mesh.radius <= 0.08:
		middle_break()
	
	if middle_mesh.visible == false:
		game_over()
	
	
	#Calculate the mid-point of two players
	mid_point_x = (player_1.global_position.x + player_2.global_position.x) / 2
	mid_point_y = ((player_1.global_position.y + player_2.global_position.y) / 2) + 1.4
	mid_point_z = (player_1.global_position.z + player_2.global_position.z) / 2
	mid_point_calc = Vector3(mid_point_x, mid_point_y, mid_point_z)
	#Move the middle mesh in between
	middle_mesh.global_position.x = player_2.global_position.x
	middle_mesh.global_position.z = player_2.global_position.z
	middle_mesh.global_position.y = player_2.global_position.y + 1.5
	
	#Rotate the middle mesh to player 1
	middle_mesh.look_at(Vector3(player_1.position.x, player_1.position.y + 1.5, player_1.position.z))
	
	
	#Pull player 1 towards middle mesh
	player_1.velocity.x = -(player_1.global_position.x - mid_point_calc.x)
	player_1.velocity.z = -(player_1.global_position.z - mid_point_calc.z)
	
	player_2.velocity.x = -(player_2.global_position.x - mid_point_calc.x)
	player_2.velocity.z = -(player_2.global_position.z - mid_point_calc.z)
	
	if player_1.is_on_floor() == false:
		player_1.velocity.x = player_1.velocity.x * (player_1.global_position.distance_to(player_2.global_position) * 2)
		player_1.velocity.z = player_1.velocity.z * (player_1.global_position.distance_to(player_2.global_position) * 2)
	if player_2.is_on_floor() == false:
		player_2.velocity.x = player_2.velocity.x * (player_2.global_position.distance_to(player_1.global_position) * 2)
		player_2.velocity.z = player_2.velocity.z * (player_2.global_position.distance_to(player_1.global_position) * 2)
	
	#Calculate the distance of player 1 and player 2
	player_distance = abs(player_1.global_position - player_2.global_position)
	
	#Stretch the middle mesh based on distance
	mesh.mesh.height = 0.3 + player_1.global_position.distance_to(player_2.global_position)
	mesh.mesh.radius =  0.5 - (player_1.global_position.distance_to(player_2.global_position) * 0.05)
	
	#Check player distance from each other
	#Adjust player speed

	if player_distance.x + player_distance.z < 5:
		Globals.speed_player_1 = 5.0
		Globals.speed_player_2 = 5.0

	elif player_distance.x + player_distance.z > 5:
		Globals.speed_player_1 = 2
		Globals.speed_player_2 = 2


func middle_break():
	middle_mesh.visible = false

func game_over():
	player_1.process_mode = Node.PROCESS_MODE_DISABLED
	player_2.process_mode = Node.PROCESS_MODE_DISABLED
	game_over_label.visible = true

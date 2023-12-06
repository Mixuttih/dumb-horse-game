extends Node3D

@onready var area_3d = $middle_mesh/Area3D
@onready var middle_mesh = $middle_mesh

@onready var player_1 = $player1
@onready var player_2 = $player2
@onready var break_timer = $BreakTimer
@onready var break_label = $BreakLabel
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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if middle_mesh.visible == false:
		game_over()
	
	#Update the timer display every frame
	break_label.set_text(str(break_timer.get_time_left()).pad_decimals(1))
	
	#Calculate the mid-point of two players
	mid_point_x = (player_1.global_position.x + player_2.global_position.x) / 2
	mid_point_y = ((player_1.global_position.y + player_2.global_position.y) / 2) + 1.4
	mid_point_z = (player_1.global_position.z + player_2.global_position.z) / 2
	mid_point_calc = Vector3(mid_point_x, mid_point_y, mid_point_z)
	#Move the middle mesh in between
	middle_mesh.global_position = mid_point_calc
	
	#Bind the area node to middle mesh
	area_3d.position = middle_mesh.global_position
	#Rotate the middle mesh to player 1
	middle_mesh.look_at(player_1.position)
	#Rotate the middle mesh to form a body
	middle_mesh.rotation_degrees.x = 90
	
	if player_1.position.y - player_2.position.y > 0.1:
		middle_mesh.rotation_degrees.x = 90 + (player_1.position.y * 10)
	if player_2.position.y - player_1.position.y > 0.1:
		middle_mesh.rotation_degrees.x = 90 - (player_2.position.y * 20)
	
	
	
	#Calculate the distance of middle mesh and player 1
	distance = abs(player_1.global_position - middle_mesh.global_position)
	print(distance)
	#Stretch the middle mesh based on distance
	middle_mesh.mesh.height = (distance.x + distance.z) * 1.7
	
	#Pull player 1 towards middle mesh
	player_1.velocity.x = -(player_1.global_position.x - middle_mesh.global_position.x)
	player_1.velocity.z = -(player_1.global_position.z - middle_mesh.global_position.z)
	#Pull player 2 towards middle mesh
	player_2.velocity.x = -(player_2.global_position.x - middle_mesh.global_position.x)
	player_2.velocity.z = -(player_2.global_position.z - middle_mesh.global_position.z)
	
	#Calculate the distance of player 1 and player 2
	player_distance = abs(player_1.global_position - player_2.global_position)
	
	#Check player distance from each other
	#Adjust player speed
	#Start and show timer if players far enough
	if player_distance.x + player_distance.z < 4:
		Globals.speed_player_1 = 5.0
		Globals.speed_player_2 = 5.0
		if timer_running == true:
			timer_stop()
	elif player_distance.x + player_distance.z > 4:
		Globals.speed_player_1 = 2.5
		Globals.speed_player_2 = 2.5
		if timer_running == false:
			timer_start()



func timer_start():
	timer_running = true
	break_timer.start()
	break_label.visible = true

func timer_stop():
	timer_running = false
	break_timer.stop()
	break_label.visible = false
	


func _on_area_3d_body_exited(body):
	print(body)
	
	

func _on_area_3d_body_entered(body):
	print(body)
	

func _on_break_timer_timeout():
	middle_mesh.visible = false

func game_over():
	break_timer.stop()
	player_1.process_mode = Node.PROCESS_MODE_DISABLED
	player_2.process_mode = Node.PROCESS_MODE_DISABLED
	game_over_label.visible = true

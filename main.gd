extends Node3D

@onready var area_3d = $middle_mesh/Area3D
@onready var middle_mesh = $middle_mesh

@onready var player_1 = $player1
@onready var player_2 = $player2
@onready var break_timer = $BreakTimer
@onready var break_label = $BreakLabel

var mid_point_x
var mid_point_y
var mid_point_z
var mid_point_calc

var distance
var timer_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mid_point_x = (player_1.global_position.x + player_2.global_position.x) / 2
	mid_point_y = ((player_1.global_position.y + player_2.global_position.y) / 2) + 1
	mid_point_z = (player_1.global_position.z + player_2.global_position.z) / 2
	mid_point_calc = Vector3(mid_point_x, mid_point_y, mid_point_z)
	
	middle_mesh.global_position = mid_point_calc
	
	area_3d.position = middle_mesh.global_position
	middle_mesh.look_at(player_1.position)
	middle_mesh.rotation_degrees.x = 90
	
	distance = abs(player_1.global_position - middle_mesh.global_position)
	print(distance)
	
	break_label.set_text(str(break_timer.get_time_left()).pad_decimals(1))
	
	if distance.x < 1:
		Globals.speed_player_1 = 5.0
		Globals.speed_player_2 = 5.0
	elif distance.z < 0.2:
		Globals.speed_player_1 = 5.0
		Globals.speed_player_2 = 5.0
	elif distance.x > 1 and distance.x < 1.5 or distance.z > 0.2 and distance.z < 1:
		Globals.speed_player_1 = 2.5
		Globals.speed_player_2 = 2.5
		if timer_running == true:
			timer_stop()
	elif distance.x > 1.5 or distance.z > 1.5:
		Globals.speed_player_1 = 0.5
		Globals.speed_player_2 = 0.5
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

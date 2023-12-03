extends Node3D

@onready var area_3d = $middle_mesh/Area3D
@onready var middle_mesh = $middle_mesh

@onready var player_1 = $player1
@onready var player_2 = $player2

var mid_point_x
var mid_point_y
var mid_point_z
var mid_point_calc

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mid_point_x = (player_1.global_position.x + player_2.global_position.x) / 2
	mid_point_y = (player_1.global_position.y + player_2.global_position.y) / 2
	mid_point_z = (player_1.global_position.z + player_2.global_position.z) / 2
	mid_point_calc = Vector3(mid_point_x, mid_point_y, mid_point_z)
	middle_mesh.global_position = mid_point_calc
	
	area_3d.position = middle_mesh.global_position
	

func _on_area_3d_body_exited(body):
	print(body)
	Globals.speed_player_1 = 2.5
	Globals.speed_player_2 = 2.5



func _on_area_3d_body_entered(body):
	print(body)
	Globals.speed_player_1 = 5.0
	Globals.speed_player_2 = 5.0

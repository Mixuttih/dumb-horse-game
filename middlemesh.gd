extends Node3D

@onready var mesh_instance_3d = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mesh_instance_3d.position.z = -mesh_instance_3d.mesh.height / 2

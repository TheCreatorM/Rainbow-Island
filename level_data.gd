extends Node3D

@onready var world_environment: WorldEnvironment = $WorldEnvironment
const GRAYSCALE_MODEL = preload("res://materials/grayscale_model.tres")

func _ready() -> void:
	Globals.environment = world_environment.environment
	
	Globals.skymat = Globals.environment.sky.sky_material
	Globals.skymat.sky_top_color = Color(0.451, 0.451, 0.451)
	Globals.skymat.sky_horizon_color = Color(0.601, 0.601, 0.601)
	var blocks := get_tree().get_nodes_in_group("block")
	for block in blocks:
		var mat = block.materials
		mat[0] = GRAYSCALE_MODEL
		mat[0].set_shader_parameter("gray_scale",1.0)
		mat[0].set_shader_parameter("darkness",0.0)
		

func _physics_process(_delta: float) -> void:
	
	print (Globals.grayness)
	if Globals.grayness < 40:
		Globals.skymat.sky_top_color = Color(0.324, 0.424, 0.771)
		Globals.skymat.sky_horizon_color = Color(0.506, 0.615, 0.719)
		
		var blocks := get_tree().get_nodes_in_group("block")
		
		for block in blocks:
			print("WHAT THE SHIT")
			var mat = block.materials
			for m in mat:
				m.set_shader_parameter("gray_scale",0.0)
				m.set_shader_parameter("darkness",1.0)
	
	

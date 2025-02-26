extends WorldEnvironment

#const GRAYSCALE_MODEL = preload("res://materials/grayscale_model.tres")
#
#func _ready() -> void:
	#var blocks := get_tree().get_nodes_in_group("block")
	#for block in blocks:
		#var mat = block.mesh.material
		#mat = GRAYSCALE_MODEL
		#mat.set_shader_parameter("gray_scale",1.0)
		#mat.set_shader_parameter("darkness",0.0)
#func _process(delta: float) -> void:
	#environment.sky.sky_material.sky_top_color = Color(0.0, 0.0, 0.0).lerp(Color(0.999, 0.5, 0.5),1.0-(Globals.grayness/100))

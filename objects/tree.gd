extends Sprite3D

@export var player: Node3D
@onready var area: StaticBody3D = $Area3D
var material : ShaderMaterial

var grayscale : float = 1.0

const MUZZLE = preload("res://effects/particles/muzzle.tscn")

var tex : CompressedTexture2D = preload("res://assets/trees/Apple_Tree.png")
var shad : Shader = preload("res://materials/grayscale_2d.gdshader")

func _ready() -> void:
	material = ShaderMaterial.new()
	material.shader = shad
	material.set_shader_parameter("albedo_texture",tex)
	material.set_shader_parameter("scale",20.0)
	
	material_override = material
	player = get_tree().get_first_node_in_group("player")
	
func _process(_delta: float) -> void:
	# Get the position of the player
	var target_position = player.global_transform.origin
	
	# Keep only the Y-axis rotation by setting Y to match the area
	target_position.y = global_position.y
	
	# Make the area face the player along the Y-axis
	area.look_at(target_position, Vector3.UP)


#func hit() -> void:
	#if grayscale > 0:
		#Globals.grayness -= 1
		#grayscale -= 0.05
		#material_override.set_shader_parameter("gray_scale",grayscale)
		#print("make color " + str(grayscale))

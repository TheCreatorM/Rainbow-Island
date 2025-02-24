extends Sprite3D

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
	
func MakeColor() -> void:
	if grayscale > 0:
		Globals.grayness -= 1
		grayscale -= 0.05
		material_override.set_shader_parameter("gray_scale",grayscale)
		print("make color " + str(grayscale))

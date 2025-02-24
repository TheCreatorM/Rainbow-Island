extends Node3D

const MUZZLE_01 = preload("res://assets/particles/muzzle_01.png")

var active_time : float = 0.2

func _physics_process(delta: float) -> void:
	active_time -= delta
	if active_time<=0:
		for c in get_children():
			c.queue_free()	
	
func Activate() -> void:
	active_time = 0.2
	for i in range(5):
		var Spr : Sprite3D = Sprite3D.new()
		Spr.texture = MUZZLE_01
		Spr.double_sided = true
		Spr.rotate_z(randf())
		Spr.scale = Vector3(0.3,0.3,0.3)
		add_child(Spr)
		Spr.global_position = global_position
		

extends Area3D

var velocity = Vector3.ZERO


func _physics_process(delta):
	look_at(transform.origin + velocity.normalized(), Vector3.UP)
	transform.origin += velocity * delta
	
func _on_hit(body: Node3D) -> void:
	var par = get_tree().get_root().get_node(body.get_path()).get_parent()
	if par.is_in_group("hit"):
		if par.has_method("hit"):
			par.hit()
		queue_free()
	if par.is_in_group("block"):
		var mat = par.mesh.material
		mat.set_shader_parameter("gray_scale",mat.get_shader_parameter("gray_scale")-0.1)
		mat.set_shader_parameter("darkness",mat.get_shader_parameter("darkness")+0.1)
		Globals.grayness -= 1
		queue_free()

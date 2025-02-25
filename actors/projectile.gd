extends Area3D

var velocity = Vector3.ZERO


func _physics_process(delta):
	look_at(transform.origin + velocity.normalized(), Vector3.UP)
	transform.origin += velocity * delta
	
func _on_hit(body: Node3D) -> void:
	if body.is_in_group("hit"):
		get_tree().get_root().get_node(body.get_path()).get_parent().hit()
		queue_free()

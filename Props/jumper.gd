extends AnimatedSprite3D




#
func _on_jumper_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		play()
		body.velocity.y += 10

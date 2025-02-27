extends AnimatedSprite3D

var player: Node3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_position = player.global_transform.origin
	
	# Keep only the Y-axis rotation by setting Y to match the area
	target_position.y = global_position.y
	
	# Make the area face the player along the Y-axis
	look_at(target_position, Vector3.UP)



#
func _on_jumper_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		play()
		body.velocity.y += 10

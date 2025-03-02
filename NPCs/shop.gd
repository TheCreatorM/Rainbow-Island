extends Sprite3D

var dialogues
var dialogueBox = load("res://GUIs/DialogueBox.tscn")

func _ready() -> void:
	var file_access := FileAccess.open("res://Dialogues/test_dialogue.json", FileAccess.READ)
	var json_string := file_access.get_as_text()
	file_access.close()
	dialogues = JSON.parse_string(json_string).dialogues


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		var dial = dialogueBox.instantiate()
		set_process_input(false)
		dial.update_dialogue(dialogues)
		get_tree().get_root().get_node("Node3D").add_child(dial)

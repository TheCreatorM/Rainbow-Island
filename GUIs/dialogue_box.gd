extends Control

var dialogue
var label
var speaker
var n
var t
func update_dialogue(dial:Array):
	label = $Panel/Label
	speaker = $Panel/Speaker
	dialogue = dial
	n=0
	label.text = dialogue[n].text
	speaker.text = dialogue[n].speaker
	n+=1
	t=1

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
func _process(delta: float) -> void:
	t-=delta
	if t<0:
		t=0
	if (Input.is_anything_pressed() || Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) && t<=0:
		if n>=len(dialogue):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
			queue_free()
		else:
			speaker.text = dialogue[n].speaker
			label.text = dialogue[n].text
			n+=1
			t = 1

extends Control

var dialogue
var label
var speaker
var option1
var option2
var n
var t
var optioned
var gui
func start_dialogue(dial:Array, GUI: Control = null):
	label = $Panel/Label
	speaker = $Panel/Speaker
	option1 = $Panel/Option1
	option2 = $Panel/Option2
	gui = GUI
	dialogue = dial
	n=0
	update_dialogue()
	
func update_dialogue():
	label.text = dialogue[n].text
	speaker.text = dialogue[n].speaker
	if dialogue[n].has("option1") && dialogue[n].has("option2")&& dialogue[n].has("next1")&& dialogue[n].has("next2"):
		optioned = true
		option1.text = dialogue[n].option1
		option2.text = dialogue[n].option2
		option1.visible = true
		option2.visible = true
	else:
		optioned = false
		option1.visible = false
		option2.visible = false
	n+=1
	t=1

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
func _process(delta: float) -> void:
	t-=delta
	if t<0:
		t=0
	if not optioned:
		if (Input.is_anything_pressed() || Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) && t<=0:
			if n>=len(dialogue):
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				get_tree().paused = false
				queue_free()
			else:
				update_dialogue()

func _on_option_1_pressed() -> void:
	n = dialogue[n-1].next1
	if n == -2:
		gui.visible = true
		queue_free()
	elif n>=len(dialogue) || n < 0:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		queue_free()
	else:
		update_dialogue()


func _on_option_2_pressed() -> void:
	n = dialogue[n-1].next2
	if n == -2:
		gui.visible = true
	elif n>=len(dialogue) || n < 0:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		queue_free()
	else:
		update_dialogue()

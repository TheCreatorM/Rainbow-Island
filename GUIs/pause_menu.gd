extends Control


@onready var continue_button = $BoxContainer/Continue
@onready var exit_button = $BoxContainer/Exit

func _ready():
	visible = false  # Hide menu at start

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # 'Esc' by default
		if Global.ui_stack.is_empty():
			pause()
		else:
			unpause()

func pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused= true
	visible = true
	Global.ui_stack.append(self)

func unpause():
	if not Global.ui_stack.is_empty():
		Global.ui_stack.pop_back().visible = false
	
	print(len(Global.ui_stack))  # Debugging

	if Global.ui_stack.is_empty():
		get_tree().paused = false
		await get_tree().process_frame  # Ensure the pause state updates before capturing mouse
		await get_tree().process_frame 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_continue_pressed():
	unpause()

func _on_exit_pressed():
	get_tree().quit()

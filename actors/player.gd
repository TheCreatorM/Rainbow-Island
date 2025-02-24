extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.002
const COOLDOWN = 0.1

@onready var gun = $Gun

var t = 0.0
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _process(delta: float) -> void:
	t -= delta
	if t<=0.0:
		t=0.0
	if Input.is_action_just_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_pressed("shoot") and t==0.0:
			gun.play("gun")
			t=COOLDOWN
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotation.x -=event.relative.y * MOUSE_SENS
			rotation.y -=event.relative.x * MOUSE_SENS

func _physics_process(delta: float) -> void:
	# Add the gravity.
	var speed_mult = 1.0
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	if Input.is_action_pressed("sprint"):
		speed_mult*=2
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * speed_mult
		velocity.z = direction.z * SPEED * speed_mult
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

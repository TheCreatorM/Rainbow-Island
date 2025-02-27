extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.002
const PROJECTILE_SPEED = 50
const COOLDOWN = 0.66
const DASH_FORCE = 40.0  # Horizontal dash speed
const DASH_VERTICAL_REDUCTION = 0.2  # Reduce vertical influence

@onready var gun = $Gun
@onready var root = get_tree().get_root().get_node("Node3D")
@onready var projectile = load("res://Player/projectile.tscn")
@onready var cam = $Camera3D

var sliding = false
var dashing = false
var dash_cooldown = 0.0
var t = 0.0  # Shooting cooldown

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _process(delta: float) -> void:
	# Update cooldown timers
	t -= delta
	dash_cooldown -= delta
	
	# Clamp cooldown timers
	t = max(t, 0.0)
	dash_cooldown = max(dash_cooldown, 0.0)

	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	# Shooting logic with cooldown
	if Input.is_action_pressed("shoot") and t == 0.0:
		gun.play("gun")
		var proj =projectile.instantiate()
		proj.transform = global_transform.translated(Vector3(0.0,0.5,0.0))
		proj.velocity = -proj.transform.basis.z * PROJECTILE_SPEED
		root.add_child(proj)
		t = COOLDOWN

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotation.x -= event.relative.y * MOUSE_SENS
			rotation.y -= event.relative.x * MOUSE_SENS

func _physics_process(delta: float) -> void:
	# Add gravity
	var speed_mult = 1.0
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		dashing = false
		if not sliding:
			cam.position.y = 0.5

	# Dash logic with cooldown
	if Input.is_action_just_pressed("crouch"):
		if not is_on_floor() and not dashing and dash_cooldown == 0.0:
			dashing = true
			var dash_direction = -basis.z.normalized()  # Forward direction
			velocity = dash_direction * DASH_FORCE
			velocity.y *= DASH_VERTICAL_REDUCTION  # Reduce vertical velocity effect
			dash_cooldown = COOLDOWN  # Start dash cooldown
		sliding = true
		cam.position.y = -0.2

	if Input.is_action_just_released("crouch"):
		if not dashing:
			cam.position.y = 0.5
		sliding = false

	# Handle jump
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input direction and movement
	var input_dir := Input.get_vector("left", "right", "forward", "backward")

	if sliding:
		speed_mult *= 3  # Adjust sliding speed as needed
		velocity.x *= 0.95  # Apply gradual deceleration
		velocity.z *= 0.95
	elif Input.is_action_pressed("sprint"):
		speed_mult *= 2
		
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Ensure dashing only applies once
	if not dashing:
		if direction:
			velocity.x = direction.x * SPEED * speed_mult
			velocity.z = direction.z * SPEED * speed_mult
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

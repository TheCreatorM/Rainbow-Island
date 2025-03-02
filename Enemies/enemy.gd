extends CharacterBody3D

var speed: float = 2.0
var player
var health
var max_health = 50
@onready var anim = $Sprite3D
@onready var healthtxt = $SubViewport/Label
@onready var healthbar = $SubViewport/TextureProgressBar
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	health = max_health
	healthbar.max_value = max_health
	healthbar.value = health
	healthtxt.text = str(health) + " / " + str(max_health)
	anim.play()
	
func _process(_delta: float) -> void:
	# Get the position of the player
	var target_position = player.global_transform.origin
	
	# Keep only the Y-axis rotation by setting Y to match the area
	target_position.y = global_position.y
	
	# Make the area face the player along the Y-axis
	look_at(target_position, Vector3.UP)
	
func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func hit():
	health -=5
	healthbar.value = health
	healthtxt.text = str(health) + " / " + str(max_health)
	if health <= 0:
		queue_free()

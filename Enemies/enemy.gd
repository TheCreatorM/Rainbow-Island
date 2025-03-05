extends CharacterBody3D

const SPEED: float = 2.0
const COOLDOWN = 2.0
const PROJECTILE_SPEED = 50
const MAX_HEALTH = 30

var player
var health

var t = 0

@onready var root = get_tree().get_root().get_node("Node3D")

@onready var anim = $Sprite3D
@onready var healthtxt = $SubViewport/Label
@onready var healthbar = $SubViewport/TextureProgressBar
@onready var projectile = load("res://Weapons/projectile.tscn")

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	health = MAX_HEALTH
	healthbar.max_value = MAX_HEALTH
	healthbar.value = health
	healthtxt.text = str(health) + " / " + str(MAX_HEALTH)
	anim.play()
	
func _process(_delta: float) -> void:
	t -= _delta
	if t<=0:
		t=COOLDOWN
		var proj =projectile.instantiate()
		proj.transform = global_transform.translated(-global_transform.basis.z )
		proj.velocity = -proj.transform.basis.z * PROJECTILE_SPEED
		proj.set_collision_mask_value(3,true)
		proj.damage = 5
		root.add_child(proj)
	# Get the position of the player
	var target_position = player.global_transform.origin
	
	# Keep only the Y-axis rotation by setting Y to match the area
	target_position.y = global_position.y
	
	# Make the area face the player along the Y-axis
	look_at(target_position, Vector3.UP)
	
func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * SPEED
		move_and_slide()

func hit(damage:int):
	health -=damage
	healthbar.value = health
	healthtxt.text = str(health) + " / " + str(MAX_HEALTH)
	if health <= 0:
		queue_free()

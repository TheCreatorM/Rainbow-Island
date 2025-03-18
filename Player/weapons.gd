extends Node3D

@onready var crosshair = get_parent().get_node("GUI/Crosshair")
var current_weapon: Node3D = null
var t = 0.0  # Shooting cooldown
var weapon_index = 0
var weapons = []

func _ready():
	load_weapons()
	equip_weapon(1)

func _process(delta: float) -> void:
	t -= delta
	t = max(t, 0.0)
	if Input.is_action_just_pressed("next_weapon"):
		equip_weapon(weapon_index+1)
	if Input.is_action_just_pressed("previous_weapon"):
		equip_weapon(weapon_index-1)
	if Input.is_action_pressed("attack") and t == 0.0 and not get_parent().sliding:
		current_weapon.play()
		
		if current_weapon.is_ranged:
			var proj =current_weapon.projectile.instantiate()
			proj.transform = global_transform.translated(Vector3(0.0,0.5,0.0)).translated(-global_transform.basis.z )
			proj.velocity = -proj.transform.basis.z * current_weapon.projectile_speed
			proj.set_collision_mask_value(2,true)
			proj.damage = current_weapon.damage
			get_tree().get_root().add_child(proj)
			t = current_weapon.cooldown
		else:
			# do some swingi stuff and bem
			# TODO:
			t = 9999
			var hitbox = Area3D.new()
			var collision_shape = CollisionShape3D.new()
			var shape = BoxShape3D.new()

			# Configure shape
			shape.size = Vector3(current_weapon.range, 2, 0.5)
			collision_shape.shape = shape

			# Add components
			hitbox.add_child(collision_shape)
			add_child(hitbox)
			hitbox.translate(Vector3(current_weapon.range * 0.25,0,current_weapon.range * -0.5))
			hitbox.rotate_y(deg_to_rad(90-(current_weapon.arc/2)))
			
			#hitbox.position.(-global_transform.basis.x * current_weapon.range * 0.25) # Start slightly right

			

			# Detect enemies
			hitbox.body_entered.connect(_on_hitbox_body_entered)
			hitbox.area_entered.connect(_on_area_enter)
			hitbox.set_collision_mask_value(5,true)

			#  Swing motion (rotation + movement together)
			var tween = create_tween().set_parallel()

			# Rotate around Y-axis (in local space)
			tween.tween_property(hitbox, "rotation_degrees:y", 90+current_weapon.arc/2, current_weapon.duration)

			tween.tween_property(hitbox, "position:x", hitbox.position.x - current_weapon.range * 0.5, current_weapon.duration)

			#  Remove hitbox after attack
			await get_tree().create_timer(current_weapon.duration).timeout
			hitbox.queue_free()
			t = current_weapon.cooldown



		
func load_weapons():
	# Preload weapons and add them to the weapon holder
	weapons.append(load("res://Weapons/gun.tscn").instantiate())
	weapons.append(load("res://Weapons/stop_sign.tscn").instantiate())

	for weapon in weapons:
		add_child(weapon)
		weapon.hide()  # Hide all at start

func equip_weapon(index):
	if current_weapon:
		current_weapon.hide()
	
	weapon_index = index % weapons.size()
	current_weapon = weapons[weapon_index]
	if current_weapon.is_ranged:
		crosshair.visible = true
	else:
		crosshair.visible = false
	current_weapon.show()
	
func _on_hitbox_body_entered(body):
	if body.has_method("hit"):
		body.hit(current_weapon.damage)

func _on_area_enter(area):
	if area.get_collision_mask() & (1<<2):
		area.set_collision_mask_value(3,false)
		area.set_collision_mask_value(2,true)
		area.velocity = -area.velocity

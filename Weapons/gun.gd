extends AnimatedSprite3D


@export var damage: int = 5
@export var cooldown: float = 0.66
@export var is_ranged: bool = true
@export var projectile_speed = 50
@export var projectile: Resource = load("res://Weapons/projectile.tscn")

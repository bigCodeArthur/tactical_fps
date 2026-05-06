class_name BulletSpawner extends Node3D

const BASIC_BULLET = preload("uid://dd8q3wwhmbqcn")

@export var player: Player
@export var weapon_manager: WeaponManager
@export var bullet_target: RayCast3D
@export var gun_audio: PlayerGunAudio

@onready var starting_rotation = rotation


func _ready() -> void:
	position.y = weapon_manager.gun.bullet_vertical_offset


func fire_bullet() -> bool:
	var mag = weapon_manager.gun.mag
	if mag.ammo <= 0: return false
	weapon_manager.gun.mag.ammo -= 1

	gun_audio.play_sound("shot")

	var bullet = BASIC_BULLET.instantiate() as Node3D
	bullet.position = global_position

	bullet_target.target_position = Vector3(0, 0, -100)
	bullet_target.force_raycast_update()
	if bullet_target.is_colliding(): look_at(bullet_target.get_collision_point())
	else: rotation = starting_rotation
	bullet_target.target_position = Vector3.ZERO

	bullet.rotation = global_rotation
	player.get_parent().add_child(bullet)

	return true

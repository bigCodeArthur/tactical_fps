extends Node3D

const BULLET_HOLE = preload("uid://ryv0adamairv") 
const SPEED: float = 120
const GRAVITY: float = 0.05

var gravity_strength: float = 0
var spawn_time_ms: int = Time.get_ticks_msec()
var despawn_time_ms: int = 10000

@onready var pivot: Node3D = $Pivot
@onready var mesh_instance_3d: MeshInstance3D = $Pivot/MeshInstance3D
@onready var ray_cast_3d: RayCast3D = $Pivot/RayCast3D


func _process(delta: float) -> void:
	ray_cast_3d.target_position.z = -(SPEED * delta)
	ray_cast_3d.force_raycast_update()

	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		if collider is CharacterBody3D: print(collider) # TODO: damage player or enemy
		else: spawn_bullet_hole()
		queue_free()

	var next_pos := Vector3.ZERO
	next_pos += transform.basis * Vector3.FORWARD * SPEED * delta
	next_pos += transform.basis * Vector3.DOWN * gravity_strength * delta

	if next_pos != Vector3.ZERO:
		var desired := pivot.global_transform.looking_at(pivot.global_position + next_pos)
		pivot.global_transform = pivot.global_transform.interpolate_with(desired, 0.2)

	gravity_strength += GRAVITY
	position += next_pos

	mesh_instance_3d.scale += Vector3(1, 1, 1) * 0.3
	mesh_instance_3d.scale = mesh_instance_3d.scale.clamp(Vector3.ONE, Vector3.ONE * 100)

	if Time.get_ticks_msec() > spawn_time_ms + despawn_time_ms: queue_free()


func spawn_bullet_hole():
	var bullet_normal := ray_cast_3d.get_collision_normal()
	if  bullet_normal == Vector3.ZERO: return
	var bullet_hole := BULLET_HOLE.instantiate() as Node3D
	bullet_hole.position = ray_cast_3d.get_collision_point()
	get_parent().add_child(bullet_hole)
	bullet_hole.look_at(bullet_hole.position + bullet_normal)
	# bullet_hole.global_rotation = bullet_hole.global_rotation.slerp(global_rotation, 0)

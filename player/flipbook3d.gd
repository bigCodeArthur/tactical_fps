class_name Flipbook3D extends MeshInstance3D

var animation_lock: bool = false
var animation_subframe: float = 0.0
var animation_row: int = 0
var animation_start: int = 0
var animation_end: int = 0
var fallback_frame: Vector2i: 
	set(value):
		fallback_frame = value
		animation_subframe = fallback_frame.x
		animation_row = fallback_frame.y
		_update_shader_frame()
var callable: Callable = empty

@export var animation_fps: float = 30.0

@onready var weapon_manager: WeaponManager = %weaponManager


func _ready() -> void:
	# Set atlas size once for the shader.
	var atlas_size := Vector2(weapon_manager.gun.columns, weapon_manager.gun.rows)
	set_instance_shader_parameter("atlas_size", atlas_size)

	# Initialize the first frame.
	_update_shader_frame()


func _process(delta: float) -> void:
	if animation_start != animation_end: continue_animation(delta)


func play_animation(row: int, start: int, end: int, call_after: Callable = empty) -> void:
	animation_lock = true
	# +1 for integer rounding when playing backward.
	animation_subframe = float(start if start < end else start + 1)
	animation_row = row
	animation_start = start
	animation_end = end
	callable = call_after
	_update_shader_frame()


func continue_animation(delta: float) -> void:
	var animation_done: bool = false
	if animation_start < animation_end:
		animation_done = animation_subframe >= float(animation_end)
		animation_subframe += delta * animation_fps
	else:
		# +1 for integer rounding when playing backward.
		animation_done = animation_subframe <= float(animation_end + 1)
		animation_subframe -= delta * animation_fps

	if animation_done and animation_lock:
		animation_lock = false

		animation_subframe = fallback_frame.x
		animation_row = fallback_frame.y

		animation_start = 0
		animation_end = 0

		callable.call()

	_update_shader_frame()


func _update_shader_frame() -> void:
	var frame := int(animation_subframe)
	var frame_index := animation_row * weapon_manager.gun.columns + frame
	set_instance_shader_parameter("frame", frame_index)


func empty(): pass

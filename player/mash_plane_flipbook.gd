class_name MeshInstance3DFlipbook extends MeshInstance3D

var animation_lock: bool = false
var animation_subframe: float = 0
var animation_row: int = 0
var animation_start: int = 0
var animation_end: int = 0
var TEST_LAST := []

@onready var weapon_manager: WeaponManager = %weaponManager
@onready var mat := mesh.surface_get_material(0) as StandardMaterial3D


func _process(delta: float) -> void:
	continue_animation(delta)


func _ready() -> void:
	mat.uv1_scale = weapon_manager.gun.get_scale()


func play_animation(row: int, start: int, end: int):
	animation_lock = true
	# +1 for integer rounding
	animation_subframe = start if start < end else start + 1
	animation_row = row
	animation_start = start
	animation_end = end


func continue_animation(delta: float):
	if animation_start == animation_end: return

	var animation_done: bool
	if animation_start < animation_end:
		animation_done = animation_subframe >= animation_end
		animation_subframe += delta * 30
	else:
		# +1 for integer rounding
		animation_done = animation_subframe <= animation_end + 1
		animation_subframe += -delta * 30

	if animation_done and animation_lock:
		animation_subframe = 0.0
		animation_lock = false
		animation_row = weapon_manager.state
		animation_start = 0
		animation_end = 0

	var frame = int(animation_subframe)
	mat.uv1_offset = weapon_manager.gun.tile(Vector2(frame, animation_row))

	#TODO: remove debug prints
	#if [frame, animation_row] != TEST_LAST:
		#print([frame, animation_row])
		#TEST_LAST = [frame, animation_row]
		#if [frame, animation_row] == [0, 0]: print("====================")

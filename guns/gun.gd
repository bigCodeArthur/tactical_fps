class_name Gun extends Resource

enum state {
	DEFAULT,
	AIMING,
	UNLOADING,
	COCKED,
}

var current_state = 0

static var state_tile: Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(0, 2),
	Vector2i(0, 4),
	Vector2i(3, 5),
]

func get_fallback_frame() -> Vector2i: return state_tile.get(current_state)

var current_tile: Vector2i = Vector2i.ZERO

@export_group("visuals")
@export var sprite_sheet: CompressedTexture2D
@export var normal_sheet: CompressedTexture2D
@export var ORM_sheet: CompressedTexture2D

@export var rows: int
@export var columns: int

@export var bullet_vertical_offset: float
@export var bullet_aim_vertical_offset: float

@export_group("stats")
@export var mag: Mag
@export_enum(
	"9×19mm",    # smg
	"5.56×45mm", # ar
	"7.62×51mm", # mr
	"12 Gauge"   # sg
) var type: int = 0


func unload_mag():
	pass


func load_mag(mag: Mag):
	pass


func get_scale() -> Vector3:
	return Vector3(1.0 / columns, 1.0 / rows, 0)


func tile(tile_pos: Vector2i = current_tile) -> Vector3:
	current_tile = tile_pos
	var v2 := Vector2(tile_pos) * Vector2(1.0 / columns, 1.0 / rows)
	return Vector3(v2.x, v2.y, 0.0)

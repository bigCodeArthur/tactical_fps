class_name Mag extends Resource

enum state {
	FULL,
	SEMI_FULL,
	EMPTY,
}

var current_state = 0

static var state_tile: Array[Vector2i] = [
	Vector2i(7, 4),
	Vector2i(7, 4),
	Vector2i(1, 4),
]

func get_fallback_frame() -> Vector2i: return state_tile.get(current_state)


@export var max_ammo: int = 12
@export var ammo: int = 12: 
	set(value): 
		ammo = value
		if ammo == 0: current_state = state.EMPTY
		elif ammo < max_ammo: current_state = state.SEMI_FULL
		else: current_state = state.FULL

@export_enum(
	"9×19mm",    # smg
	"5.56×45mm", # ar
	"7.62×51mm", # mr
	"12 Gauge"   # sg
) var type: int = 0

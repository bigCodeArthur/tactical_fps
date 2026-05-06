extends Node3D

const textures = [
	preload("uid://dxetrcgmtelo3"),
	preload("uid://tgq4ork77tnr"),
	preload("uid://d3ww3jgsrolc0"),
	preload("uid://wh3u05uphm12"),
	preload("uid://fnkho51cyj13"),
	preload("uid://obyo1u1pai5b"),
	preload("uid://mjbdqndei5al"),
	preload("uid://c3sg0h6kw8ejm"),
	preload("uid://ffxx8x25k0w7"),
	preload("uid://riybyw0nhkfb"),
	preload("uid://b7gvmxsfw8v2s"),
	preload("uid://rtf10utpdp1l"),
	preload("uid://bniskmt58xyk6"),
	preload("uid://dx1f7gyha064e"),
	preload("uid://csd1yjl7aep5p"),
	preload("uid://d0rlqnfaxqiwh"),
	preload("uid://dyx0iqlpimat8"),
	preload("uid://bg256c2bfdmw8"),
	preload("uid://kikp82tnj4ia"),
	preload("uid://hqqjd3nmy03u"),
	preload("uid://cxiysujtrft0n"),
	preload("uid://dab5qseq054y"),
	preload("uid://ci8oyoo6ivej2"),
	preload("uid://bgh4qi7av1lwh"),
	preload("uid://cuf6wfhsthy6m"),
	preload("uid://c0qwbicdak4yt"),
	preload("uid://bvow5xwvp6elc"),
	preload("uid://dli7x833fcdsc"),
	preload("uid://mp3hqc1ilaui"),
	preload("uid://cotupe3vi7mcd"),
	preload("uid://cg285ptplpyts"),
	preload("uid://nnxrg8kdjmgh"),
	preload("uid://33bh7qd7ciet"),
	preload("uid://xun2loevwmhw"),
	preload("uid://xxxw3vngm3a5"),
	preload("uid://lh13k2il6u45"),
	preload("uid://bibuqvrjlyc8q"),
	preload("uid://dp0wwqcaeu23n"),
	preload("uid://b14l0ma81lqlh"),
	preload("uid://ceev7qi4378vt"),
	preload("uid://bfmskhscd41mw"),
	preload("uid://d13aghvi7imi4"),
	preload("uid://xbexu6xs556v"),
	preload("uid://2xdqqriidcma"),
	preload("uid://dpq58t18r6njb"),
	preload("uid://b15bl1pn0pmkr"),
	preload("uid://nsflxti0rfk7"),
	preload("uid://cdqxvxk475hk7"),
	preload("uid://bq5r0lungmjnx"),
	preload("uid://c06tx71c6nav4"),
	preload("uid://b4nekp02kfdca"),
	preload("uid://dddonq6d4k014"),
	preload("uid://bw6yu5gpesicr"),
	preload("uid://q0s3v532m3t0"),
	preload("uid://dh5ikcgrcoqhy"),
	preload("uid://ivf7s7byxoit"),
	preload("uid://b5qkgepj3omqb"),
	preload("uid://dmvgjshejbelk"),
	preload("uid://1786ot55hl77"),
	preload("uid://b2octsbp64hgn"),
	preload("uid://dd1ibpbwd3a4c"),
	preload("uid://c3xrsa8ecyslo"),
	preload("uid://c8wq0poyfvxb1"),
	preload("uid://b8xbk078i26o0"),
]

@onready var decal: Decal = $Decal
@onready var spawn_time_ms: int = Time.get_ticks_msec()
var despawn_time_ms: int = 30000


func _ready() -> void:
	decal.texture_albedo = textures[remap(randf(), 0, 1, 0, textures.size())]


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() > spawn_time_ms + despawn_time_ms: 
		# TODO: smoothely disapear
		queue_free()

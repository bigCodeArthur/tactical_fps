shader_type spatial;
render_mode cull_back, depth_draw_opaque;

// === TEXTURES ===
uniform sampler2D albedo_texture : source_color;
uniform bool use_normal_map = false;
uniform sampler2D normal_texture : hint_normal;
uniform bool use_orm_map = false;
uniform sampler2D orm_texture; // AO (R), Roughness (G), Metallic (B)

// === ATLAS SETTINGS ===
uniform vec2 atlas_size = vec2(4.0, 4.0); // columns, rows
uniform vec2 tile_padding = vec2(0.002);  // helps prevent bleeding

// === PER-INSTANCE ===
instance uniform int frame = 0;
instance uniform vec2 uv_offset = vec2(0.0);

// --- Shared UV remap ---
vec2 get_flipbook_uv(vec2 base_uv) {
	vec2 tile_size = 1.0 / atlas_size;

	int col = frame % int(atlas_size.x);
	int row = frame / int(atlas_size.x);

	vec2 tile_origin = vec2(float(col), float(row)) * tile_size;

	vec2 uv = base_uv;

	// Shrink slightly to avoid bleeding
	uv = uv * (tile_size - tile_padding) + tile_origin + tile_padding * 0.5;

	// Optional offset (for variation/scrolling)
	uv += uv_offset * tile_size;

	return uv;
}


void fragment() {
	vec2 uv = get_flipbook_uv(UV);

	// === SAMPLE TEXTURES ===
	vec4 albedo = texture(albedo_texture, uv);
	vec3 normal = texture(normal_texture, uv).rgb;
	vec3 orm = texture(orm_texture, uv).rgb;

	// === APPLY ===
	ALBEDO = albedo.rgb;
	ALPHA = albedo.a;

	if (textureSize(normal_texture, 0).x > 0) {
		NORMAL_MAP = texture(normal_texture, uv).rgb;
	} else {
		NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	}
	
	
	if (use_normal_map) {
		NORMAL_MAP = texture(normal_texture, uv).rgb;
	} else {
		NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	}

	if (use_orm_map) {
		vec3 orm = texture(orm_texture, uv).rgb;
		AO = orm.r;
		ROUGHNESS = orm.g;
		METALLIC = orm.b;
	} else {
		AO = 1.0;
		ROUGHNESS = 1.0;
		METALLIC = 0.0;
	}

	SPECULAR = 0.5;
}
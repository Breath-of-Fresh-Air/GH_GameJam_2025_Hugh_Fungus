shader_type canvas_item;

// --- User Controls ---
uniform float spore_size : hint_range(0.01, 0.3) = 0.08;
uniform float spore_speed = 0.1;
uniform float spore_brightness = 0.4;
uniform float pulse_speed = 0.3;

// --- Internal ---
float rand(vec2 co) {
	return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // --- Pulse ---
    float pulse = (sin(TIME * pulse_speed) * 0.5 + 0.5) * 0.2;
    tex.rgb += pulse;

    // --- Spores (simple drifting dots) ---
    // One spore per "grid square"
    vec2 grid = vec2(20.0, 20.0); // density is fixed to keep this simple
    vec2 cell = floor(UV * grid);
    vec2 randPos = vec2(rand(cell), rand(cell + 10.0));

    // Move spores up or down depending on speed sign
    randPos.y = fract(randPos.y + TIME * spore_speed);

    // Local UV inside this grid cell
    vec2 local = fract(UV * grid);

    // Distance from spore center
    float d = distance(local, randPos);

    // Soft glow per spore
    float spore = smoothstep(spore_size, 0.0, d) * spore_brightness;

    tex.rgb += spore;

    COLOR = tex;
}

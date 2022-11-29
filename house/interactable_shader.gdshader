shader_type spatial;
instance uniform float enable = 0.0;

void fragment() {
	ALBEDO = vec3(1.0, 1.0, 1.0);
	ALPHA = 0.1 * enable;
}

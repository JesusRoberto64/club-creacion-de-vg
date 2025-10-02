shader_type canvas_item;

uniform float mask : hint_range(0.0, 1.0)= 0.5;
uniform float deep : hint_range(0.0, 1.0) = 0.3;
uniform float fade_width : hint_range(0.0, 0.5) = 0.1;
uniform float amaunt : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	// gris de percepción de ojo humano
	float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.144)) - deep;
	// tranciciòn de escala de grises
	float t = smoothstep(mask, mask + fade_width, UV.x);

	vec3 final_color = mix(tex.rgb, vec3(gray), t * amaunt);

	COLOR = vec4(final_color, tex.a);
}

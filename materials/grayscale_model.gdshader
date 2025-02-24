shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform float gray_scale : hint_range(0,1) = 1.0;
uniform float darkness : hint_range(0,1) = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 final_color = texture(albedo_texture,UV).rgb;
	final_color.r = mix(final_color.r,final_color.g,gray_scale);
	final_color.b = mix(final_color.b,final_color.g,gray_scale);
	/*final_color.r /= gray_scale;
	final_color.g /= gray_scale;
	final_color.b /= gray_scale;*/
	ALBEDO = final_color*darkness;
	//ALPHA = texture(albedo_texture,UV).a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}


shader_type spatial;

uniform sampler2D albedo_texture : filter_nearest;
uniform float gray_scale : hint_range(0,1) = 1.0;
uniform float darkness : hint_range(0,1) = 1.0;
uniform float scale : hint_range(0,20) = 4.0;

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);
/*	vec3 billboard_offset = VERTEX - billboard;
    VERTEX.xz = normalize(INV_VIEW_MATRIX[0].xz) * billboard_offset.x + normalize(INV_VIEW_MATRIX[2].xz) * billboard_offset.z;
    VERTEX.y = billboard_offset.y;*/
	/*mat4 modified_model_view = VIEW_MATRIX * mat4(
        INV_VIEW_MATRIX[0],
        INV_VIEW_MATRIX[1],
        INV_VIEW_MATRIX[2],
        MODEL_MATRIX[3]/scale
    );
    MODELVIEW_MATRIX = modified_model_view;*/
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
	ALPHA = texture(albedo_texture,UV).a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}


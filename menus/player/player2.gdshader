shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex_color = texture(TEXTURE, UV);
	float red_amount = tex_color.b * 1.9f;
	float green_amount = tex_color.g / 1.1f;
	float blue_amount = tex_color.b / 1.2f;
    vec4 new_color = vec4(red_amount, green_amount, blue_amount, tex_color.a);
	
	COLOR = new_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

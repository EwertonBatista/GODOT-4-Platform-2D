shader_type canvas_item;

uniform float lines = 10;
uniform float threshold: hint_range(0.0, 1.0) = 0.0;
uniform vec4 line_color_a: source_color = vec4(1.0);
uniform vec4 line_color_b: source_color = vec4(.0,.0,.0,.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

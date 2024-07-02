shader_type canvas_item;

// The ring's thickness in UV space.
// The value should be between 0 to 1, but small values will work best.
uniform float torus_thickness : hint_range(0.001, 1.0) = 0.015;
// How soft a gradient we draw inside the ring. A torus is like a 3D ring, so
// this algorithm allows you to draw more than just a disk with a hole in the
// middle.
// The default negative value makes the shape fully opaque and sharp.
uniform float torus_hardness = -2.0;
// The shape's radius in UV space, that is, relative to the node's bounding box.
// The default value of 0.5 means the shape will take as much space as it can
// inside the bounding box.
uniform float torus_radius = 0.5;

void fragment() {
	// Distance of each fragment to the node's center, in UV space.
	float torus_distance = length((UV - vec2(0.5)));
	// The radius of the ring we'll draw in UV space.
	float radius_distance = torus_thickness / 2.0;
	// The radius of the empty inner circle, which will appear transparent.
	float inner_radius = torus_radius - radius_distance;

	// We calculate a base value for each fragment or pixel in the ring.
	// The fragments on the outer edges of the ring will have a value close to 0 and the fragments in the middle a value of 1.0.
	float circle_value = clamp(abs(torus_distance - inner_radius) / torus_thickness, 0.0, 1.0);
	// We use the power function to make the values that are above zero really close to 1, making our ring flat and sharp.
	float circle_alpha = pow(circle_value, pow(torus_hardness, 2.0));

	// The way we calculate our mask, we have to reverse the values to draw the ring instead of everything but the ring.
	float mask = abs(1.0 - circle_alpha);

	// Finally, we output the calculated values to the screen.
	// The type vec4 below represents a color with the four RGBA channels.
	COLOR = vec4(mask);
}
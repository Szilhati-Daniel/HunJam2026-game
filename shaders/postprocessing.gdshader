shader_type canvas_item;

uniform vec4 brightColour = vec4(1.0, 0.9843137255, 0.8313725490, 1.0);
uniform vec4 darkColour = vec4(0.1647058824, 0.1098039216, 0.0549019608, 1.0);
uniform float treshold = 0.67;

// If you intend to read from mipmaps with `textureLod()` LOD values greater than `0.0`,
// use `filter_nearest_mipmap` instead. This shader doesn't require it.
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

float calculateBrightness(vec4 colour) {
	// https://stackoverflow.com/a/596243
	float brightness = 0.2126 * colour.r + 0.7152 * colour.g + 0.0722 * colour.b;
	return float(brightness > treshold);
}

void fragment() {
    vec4 colour = textureLod(screen_texture, SCREEN_UV, 0.0);
	float brightness = calculateBrightness(colour);
	vec4 finalColour = mix(darkColour, brightColour, brightness);
	COLOR = finalColour;
}
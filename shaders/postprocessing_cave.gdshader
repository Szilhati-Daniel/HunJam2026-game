shader_type canvas_item;

uniform vec4 brightColour = vec4(1.0, 0.9843137255, 0.8313725490, 1.0);
uniform vec4 darkColour = vec4(0.1647058824, 0.1098039216, 0.0549019608, 1.0);
uniform float treshold = 0.67;

uniform vec2 lightCentre = vec2(0.0, 0.0);
uniform float lightRadius = 0.25;
uniform float lightSmoothing = 0.0;

// If you intend to read from mipmaps with `textureLod()` LOD values greater than `0.0`,
// use `filter_nearest_mipmap` instead. This shader doesn't require it.
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

float calculateLightness(vec2 position) {
	float dstFromCentre = length(lightCentre - position);
	return 1.0 - smoothstep(lightRadius, lightRadius + lightSmoothing, dstFromCentre);
}

float calculateBrightness(vec4 colour) {
	// https://stackoverflow.com/a/596243
	float brightness = 0.2126 * colour.r + 0.7152 * colour.g + 0.0722 * colour.b;
	return float(brightness > treshold);
}

void fragment() {
	float aspectRatio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 correctedUV = (SCREEN_UV - 0.5) / vec2(aspectRatio, 1.0);
    vec4 colour = textureLod(screen_texture, SCREEN_UV, 0.0);
	float lightness = calculateLightness(correctedUV);
	float brightness = calculateBrightness(colour);
	vec4 finalColour = mix(darkColour, brightColour, brightness * lightness);
	COLOR = finalColour;
}
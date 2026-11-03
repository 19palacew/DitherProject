shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D noiseTexture : source_color;

float rgbToGreyScale(vec3 color){
	// Convert to Greyscale
	// https://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
	float yLin = 0.2126f*color.r + 0.7152f*color.g + 0.0722f*color.b;
	float ySRGB;
	if(yLin <= 0.0031308f){
		ySRGB = 12.92f * yLin;
	} else {
		ySRGB = 1.055f * pow(yLin, 1.0f/2.4f) - 0.055f;
	}
	return ySRGB;
}

void fragment() {
	vec2 newUV = UV;
	//newUV.x = newUV.x + 0.50f;
	vec4 textureColor = texture(screen_texture, newUV);
	float noisePixel = texture(noiseTexture, newUV).r;
	float pixelColor =  rgbToGreyScale(textureColor.rgb);
	
	//Thresholding
	if(pixelColor>0.75f){
		pixelColor = 1.0f;
	} else if (pixelColor>0.5f){
		pixelColor = 0.50f;
	} else if (pixelColor>0.25f){
		pixelColor = 0.25f;
	} else {
		pixelColor = 0.0f;
	}
	
	// Apply Noise
	pixelColor = (pixelColor + noisePixel)/2;

	textureColor.rgb = vec3(pixelColor, pixelColor, pixelColor);
	COLOR = textureColor;
}
//MostlyMadProductions - Youtube Toturial www.youtube.com/watch?v=QYGeXW4yayU
shader_type canvas_item;
uniform vec4 OutlineColor : source_color = vec4(0.7765, 0.8745, 0.2314, 0.8667);
uniform bool CornerPixel = false;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	if (base.a > 0.0) {
		COLOR = base;
	}
	else {
		vec2 ImagePixelSize = TEXTURE_PIXEL_SIZE;
		bool ValidSide =
			texture(TEXTURE, UV + vec2(-ImagePixelSize.x, 0)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(ImagePixelSize.x, 0)).a  > 0.0 ||
			texture(TEXTURE, UV + vec2(0, -ImagePixelSize.y)).a  > 0.0 ||
			texture(TEXTURE, UV + vec2(0, ImagePixelSize.y)).a > 0.0;
		bool ValidCorner = 
			texture(TEXTURE, UV + vec2(-ImagePixelSize.x, -ImagePixelSize.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(ImagePixelSize.x,  -ImagePixelSize.y)).a  > 0.0 ||
			texture(TEXTURE, UV + vec2(-ImagePixelSize.x, ImagePixelSize.y)).a  > 0.0 ||
			texture(TEXTURE, UV + vec2(ImagePixelSize.x, ImagePixelSize.y)).a > 0.0;
		
		if (ValidSide || (CornerPixel && ValidCorner))
			COLOR = OutlineColor;
	}
}

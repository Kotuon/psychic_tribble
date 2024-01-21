shader_type canvas_item;

//uniform vec4 flash_color : source_color;
uniform float input_value = 1.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
    COLOR.rgb = (color.rgb * input_value);
}

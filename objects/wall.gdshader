shader_type canvas_item;

uniform vec4 tint_color : source_color;
//uniform float square = sqrt(0.1 * 0.1 + 0.1 * 0.1);
uniform float radius : hint_range(0.0,0.5) = 0.1;

void fragment() {
    COLOR = texture(TEXTURE, UV) * tint_color;

    if (UV.x <= radius && UV.y <= radius) {
        float to_use = min(UV.x, UV.y);
        COLOR.a = (sqrt(2.0 * (to_use * to_use))) / (sqrt(2.0 * (radius * radius)));
    }
    else if (UV.x >= (1.0 - radius) && UV.y <= radius) {
        float x = 1.0 - UV.x;
        float to_use = min(x, UV.y);
        COLOR.a = (sqrt(2.0 * (to_use * to_use))) / (sqrt(2.0 * (radius * radius)));
    }
    else if (UV.x <= radius && UV.y >= (1.0 - radius)) {
        float y = 1.0 - UV.y;
        float to_use = min(UV.x, y);
        COLOR.a = (sqrt(2.0 * (to_use * to_use))) / (sqrt(2.0 * (radius * radius)));
    }
    else if (UV.x >= (1.0 - radius) && UV.y >= (1.0 - radius)) {
        float x = 1.0 - UV.x;
        float y = 1.0 - UV.y;
        float to_use = min(x, y);
        COLOR.a = (sqrt(2.0 * (to_use * to_use))) / (sqrt(2.0 * (radius * radius)));
    }
    else if (UV.x <= radius && UV.y > radius) {
        COLOR.a = UV.x / radius;
    }
    else if (UV.y <= radius && UV.x > radius) {
        COLOR.a = UV.y / radius;
    }
    else if (UV.x >= (1.0 - radius) && UV.y > radius) {
        float x = 1.0 - UV.x;
        COLOR.a = x / radius;
    }
    else if (UV.y >= (1.0 - radius) && UV.x > radius) {
        float y = 1.0 - UV.y;
        COLOR.a = y / radius;
    }
    //else {
    //    COLOR.a = 1.0;
    //}
    
    
    //COLOR.a = 1.0 - (abs(UV.x - 0.5) / 0.5);
}

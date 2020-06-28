shader_type canvas_item;

uniform bool active = true;

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    if (active) {
        COLOR = vec4(1, 1, 1, original.a);
    } else {
        COLOR = original;
    }
}
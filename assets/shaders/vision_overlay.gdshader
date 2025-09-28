shader_type canvas_item;

uniform vec2 player_position : hint_range(0.0, 1.0) = vec2(0.5, 0.5);
uniform float vision_radius : hint_range(0.0, 1.0) = 0.5;
uniform vec2 screen_size = vec2(1280.0, 720.0);

void fragment() {
    // Get the current pixel position in screen coordinates
    vec2 screen_pos = SCREEN_UV;
    
    // Calculate distance from player position
    vec2 diff = screen_pos - player_position;
    
    // Adjust for aspect ratio
    diff.x *= screen_size.x / screen_size.y;
    
    float distance = length(diff);
    
    // Create circular mask
    float alpha = 1.0;
    if (distance < vision_radius) {
        // Inside vision radius - transparent
        alpha = 0.0;
    } else {
        // Outside vision radius - create smooth falloff
        float falloff = (distance - vision_radius) / (vision_radius * 0.2);
        alpha = clamp(falloff, 0.0, 1.0);
    }
    
    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}
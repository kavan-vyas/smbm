class_name VisionOverlay
extends CanvasLayer

var overlay_rect: ColorRect
var player: Player
var vision_shader: Shader

func _ready():
    # Create the overlay
    overlay_rect = ColorRect.new()
    overlay_rect.color = Color.BLACK
    overlay_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(overlay_rect)
    
    # Load and apply the vision shader
    vision_shader = load("res://shaders/vision_overlay.gdshader")
    var shader_material = ShaderMaterial.new()
    shader_material.shader = vision_shader
    overlay_rect.material = shader_material
    
    GameManager.register_vision_overlay(self)
    
    # Wait for player to be ready
    await get_tree().process_frame
    player = GameManager.player

func _process(delta):
    if not player or not overlay_rect.material:
        return
    
    # Update shader uniforms
    var viewport_size = get_viewport().get_visible_rect().size
    var player_screen_pos = player.get_global_position()
    
    # Convert world position to screen position
    var camera = get_viewport().get_camera_2d()
    if camera:
        player_screen_pos = (player_screen_pos - camera.get_screen_center_position()) + viewport_size * 0.5
    
    # Normalize position for shader (0-1 range)
    var normalized_pos = Vector2(
        player_screen_pos.x / viewport_size.x,
        player_screen_pos.y / viewport_size.y
    )
    
    overlay_rect.material.set_shader_parameter("player_position", normalized_pos)
    overlay_rect.material.set_shader_parameter("vision_radius", player.vision_radius / 400.0)
    overlay_rect.material.set_shader_parameter("screen_size", viewport_size)

func update_vision_radius(new_radius: float):
    if player:
        player.vision_radius = new_radius
        
        # Animate the vision change
        var tween = create_tween()
        var current_radius = overlay_rect.material.get_shader_parameter("vision_radius")
        var target_radius = new_radius / 400.0
        tween.tween_method(_set_shader_radius, current_radius, target_radius, 0.3)

func _set_shader_radius(radius: float):
    if overlay_rect.material:
        overlay_rect.material.set_shader_parameter("vision_radius", radius)
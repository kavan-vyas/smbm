class_name Door
extends StaticBody2D

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D

var is_open: bool = false

func _ready():
	GameManager.register_door(self)

func open():
	if is_open:
		return
	
	is_open = true
	collision_shape.set_deferred("disabled", true)
	
	# Play door sound
	AudioManager.play_door_open()
	
	# Animate door opening
	var tween = create_tween()
	tween.parallel().tween_property(sprite, "scale", Vector2(1.2, 1.2), 0.1)
	tween.parallel().tween_property(sprite, "modulate", Color(1, 1, 1, 0.5), 0.1)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1)

func close():
	if not is_open:
		return
	
	is_open = false
	collision_shape.set_deferred("disabled", false)
	sprite.scale = Vector2.ONE
	sprite.modulate = Color.WHITE
class_name Collectible
extends Area2D

@export var collectible_type: String = "purge_token"
@onready var sprite = $Sprite2D

var collected: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	
	# Animate the collectible
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(sprite, "rotation", PI * 2, 2.0)

func _on_body_entered(body):
	if body is Player and not collected:
		collect()

func collect():
	if collected:
		return
		
	collected = true
	
	match collectible_type:
		"purge_token":
			GameManager.player.purge_tokens += 1
		"health":
			GameManager.player.health = min(GameManager.player.health + 1, GameManager.player.initial_health)
			GameManager.player.health_changed.emit(GameManager.player.health)
	
	# Play collection sound
	AudioManager.play_collect()
	
	# Play collection animation
	var tween = create_tween()
	tween.parallel().tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.2)
	tween.parallel().tween_property(sprite, "modulate", Color.TRANSPARENT, 0.2)
	tween.tween_callback(queue_free)

func reset():
	collected = false
	sprite.scale = Vector2.ONE
	sprite.modulate = Color.WHITE
	show()
class_name Player
extends CharacterBody2D

signal health_changed(new_health: int)
signal sacrifice_applied(sacrifice_type: String)

@export var base_speed: float = 200.0
@export var initial_health: int = 3
@export var initial_vision_radius: float = 200.0

var health: int
var speed_multiplier: float = 1.0
var vision_radius: float
var can_move: Dictionary = {
	"left": true,
	"right": true,
	"up": true,
	"down": true
}
var purge_tokens: int = 0

var input_enabled: bool = true

func _ready():
	reset_to_defaults()

func _physics_process(delta):
	if not input_enabled or GameManager.game_paused:
		return
	
	var input_vector = Vector2.ZERO
	
	# Get input with directional restrictions
	if can_move.left and Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if can_move.right and Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if can_move.up and Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if can_move.down and Input.is_action_pressed("move_down"):
		input_vector.y += 1
	
	# Normalize and apply speed
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		velocity = input_vector * base_speed * speed_multiplier
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func apply_sacrifice(sacrifice_type: String):
	match sacrifice_type:
		"health":
			health -= 1
			health_changed.emit(health)
			_flash_red()
		"speed":
			speed_multiplier *= 0.8
		"vision":
			vision_radius *= 0.75
		"dir_left":
			can_move.left = false
		"dir_right":
			can_move.right = false
		"dir_up":
			can_move.up = false
		"dir_down":
			can_move.down = false
		"timer":
			GameManager.time_remaining -= 10.0
	
	sacrifice_applied.emit(sacrifice_type)
	AudioManager.play_sacrifice()
	_apply_slowmo_effect()

func reset_to_defaults():
	health = initial_health
	speed_multiplier = 1.0
	vision_radius = initial_vision_radius
	can_move = {
		"left": true,
		"right": true,
		"up": true,
		"down": true
	}
	purge_tokens = 0
	input_enabled = true
	
	health_changed.emit(health)

func set_input_enabled(enabled: bool):
	input_enabled = enabled

func _flash_red():
	# Create a red flash effect
	var tween = create_tween()
	modulate = Color.RED
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)

func _apply_slowmo_effect():
	# Brief slowmo effect
	var original_scale = Engine.time_scale
	Engine.time_scale = 0.3
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.25
	timer.one_shot = true
	timer.timeout.connect(func(): 
		Engine.time_scale = original_scale
		timer.queue_free()
	)
	timer.start()
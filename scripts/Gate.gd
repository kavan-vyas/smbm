class_name Gate
extends Area2D

@export var option_a: String = "health"
@export var option_b: String = "dir_left"
@export var option_a_text: String = "Sacrifice: -1 Heart"
@export var option_b_text: String = "Sacrifice: Disable Left"
@export var door: Door

var is_used: bool = false
var player_in_range: bool = false

signal gate_activated(gate: Gate)

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	GameManager.register_gate(self)

func _on_body_entered(body):
	if body is Player and not is_used:
		player_in_range = true
		gate_activated.emit(self)

func _on_body_exited(body):
	if body is Player:
		player_in_range = false

func choose_option(option: String):
	if is_used:
		return
	
	is_used = true
	var player = GameManager.player
	
	if option == "A":
		player.apply_sacrifice(option_a)
	else:
		player.apply_sacrifice(option_b)
	
	# Open the door
	if door:
		door.open()
		_play_door_sound()
	
	# Disable this gate
	set_monitoring(false)

func reset():
	is_used = false
	player_in_range = false
	set_monitoring(true)

func _play_door_sound():
	# Play door opening sound
	var audio_player = AudioStreamPlayer2D.new()
	add_child(audio_player)
	# Note: You'll need to add actual audio files
	# audio_player.stream = preload("res://audio/door_open.ogg")
	# audio_player.play()
	
	# Remove after playing
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(func(): 
		audio_player.queue_free()
		timer.queue_free()
	)
	timer.start()
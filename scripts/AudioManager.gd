extends Node

# Audio manager for handling sound effects and music
var audio_players: Dictionary = {}

func _ready():
	# Create audio players for different sound types
	create_audio_player("door_open")
	create_audio_player("sacrifice")
	create_audio_player("collect")
	create_audio_player("ui_click")

func create_audio_player(sound_name: String):
	var player = AudioStreamPlayer.new()
	add_child(player)
	audio_players[sound_name] = player

func play_sound(sound_name: String, volume: float = 0.0):
	if sound_name in audio_players:
		var player = audio_players[sound_name]
		player.volume_db = volume
		# Note: Add actual audio files when available
		# player.stream = preload("res://audio/" + sound_name + ".ogg")
		# player.play()

func play_door_open():
	play_sound("door_open", -5.0)

func play_sacrifice():
	play_sound("sacrifice", -3.0)

func play_collect():
	play_sound("collect", -8.0)

func play_ui_click():
	play_sound("ui_click", -10.0)
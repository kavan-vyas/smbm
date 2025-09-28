class_name UIHud
extends CanvasLayer

@onready var hearts_container = $Control/TopLeft/HeartsContainer
@onready var sacrifices_container = $Control/TopRight/SacrificesContainer
@onready var timer_label = $Control/TopCenter/TimerLabel
@onready var gate_modal = $Control/GateModal
@onready var gate_text = $Control/GateModal/Panel/VBoxContainer/GateText
@onready var option_a_button = $Control/GateModal/Panel/VBoxContainer/ButtonsContainer/OptionAButton
@onready var option_b_button = $Control/GateModal/Panel/VBoxContainer/ButtonsContainer/OptionBButton
@onready var win_screen = $Control/WinScreen
@onready var lose_screen = $Control/LoseScreen
@onready var win_time_label = $Control/WinScreen/Panel/VBoxContainer/TimeLabel
@onready var best_time_label = $Control/WinScreen/Panel/VBoxContainer/BestTimeLabel
@onready var restart_button_win = $Control/WinScreen/Panel/VBoxContainer/RestartButton
@onready var restart_button_lose = $Control/LoseScreen/Panel/VBoxContainer/RestartButton
@onready var reset_button = $Control/TopLeft/ResetButton

var heart_texture = preload("res://icon.svg")  # Using default icon for now
var current_gate: Gate

func _ready():
	GameManager.register_ui_hud(self)
	
	# Connect gate system
	for gate in get_tree().get_nodes_in_group("gates"):
		if gate is Gate:
			gate.gate_activated.connect(_on_gate_activated)
	
	# Connect buttons
	option_a_button.pressed.connect(_on_option_a_pressed)
	option_b_button.pressed.connect(_on_option_b_pressed)
	restart_button_win.pressed.connect(_on_restart_pressed)
	restart_button_lose.pressed.connect(_on_restart_pressed)
	reset_button.pressed.connect(_on_restart_pressed)
	
	# Initialize UI
	gate_modal.hide()
	win_screen.hide()
	lose_screen.hide()
	
	# Wait for player to be ready
	await get_tree().process_frame
	if GameManager.player:
		update_health(GameManager.player.health)

func update_health(health: int):
	# Clear existing hearts
	for child in hearts_container.get_children():
		child.queue_free()
	
	# Add hearts based on current health
	for i in range(health):
		var heart = TextureRect.new()
		heart.texture = heart_texture
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart.custom_minimum_size = Vector2(32, 32)
		hearts_container.add_child(heart)

func add_sacrifice_indicator(sacrifice_type: String):
	var label = Label.new()
	label.add_theme_color_override("font_color", Color.RED)
	
	match sacrifice_type:
		"speed":
			label.text = "SPD-20%"
		"vision":
			label.text = "VIS-20%"
		"dir_left":
			label.text = "L✖"
		"dir_right":
			label.text = "R✖"
		"dir_up":
			label.text = "U✖"
		"dir_down":
			label.text = "D✖"
		"timer":
			label.text = "TIME-10s"
	
	sacrifices_container.add_child(label)

func update_timer(time_remaining: float):
	var minutes = int(time_remaining) / 60
	var seconds = int(time_remaining) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]
	
	# Change color when time is low
	if time_remaining < 30:
		timer_label.add_theme_color_override("font_color", Color.RED)
	else:
		timer_label.add_theme_color_override("font_color", Color.WHITE)

func _on_gate_activated(gate: Gate):
	current_gate = gate
	show_gate_modal(gate)

func show_gate_modal(gate: Gate):
	GameManager.pause_game()
	GameManager.player.set_input_enabled(false)
	
	gate_text.text = "The door demands a price. What will you give?"
	option_a_button.text = gate.option_a_text
	option_b_button.text = gate.option_b_text
	
	gate_modal.show()

func _on_option_a_pressed():
	if current_gate:
		current_gate.choose_option("A")
	hide_gate_modal()

func _on_option_b_pressed():
	if current_gate:
		current_gate.choose_option("B")
	hide_gate_modal()

func hide_gate_modal():
	gate_modal.hide()
	GameManager.unpause_game()
	GameManager.player.set_input_enabled(true)
	current_gate = null

func show_win_screen(completion_time: float, best_time: float):
	var minutes = int(completion_time) / 60
	var seconds = completion_time - (minutes * 60)
	win_time_label.text = "Time: %02d:%05.2f" % [minutes, seconds]
	
	if best_time > 0:
		var best_minutes = int(best_time) / 60
		var best_seconds = best_time - (best_minutes * 60)
		best_time_label.text = "Best: %02d:%05.2f" % [best_minutes, best_seconds]
	else:
		best_time_label.text = "Best: --:--"
	
	win_screen.show()

func show_lose_screen():
	lose_screen.show()

func _on_restart_pressed():
	win_screen.hide()
	lose_screen.hide()
	GameManager.restart_game()

func reset():
	# Clear sacrifice indicators
	for child in sacrifices_container.get_children():
		child.queue_free()
	
	# Reset timer display
	timer_label.add_theme_color_override("font_color", Color.WHITE)
	
	# Hide screens
	win_screen.hide()
	lose_screen.hide()
	gate_modal.hide()

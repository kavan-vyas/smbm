extends Node

signal player_died
signal player_won
signal time_expired

var player: Player
var ui_hud: UIHud
var vision_overlay: VisionOverlay
var gates: Array[Gate] = []
var doors: Array[Door] = []

var time_remaining: float = 120.0
var timer_enabled: bool = true
var game_paused: bool = false
var game_over: bool = false

var best_time: float = 0.0
var config_file_path = "user://best_time.cfg"

func _ready():
	load_best_time()

func _process(delta):
	# Handle reset input
	if Input.is_action_just_pressed("reset"):
		restart_game()
		return
	
	if game_over or game_paused:
		return
		
	if timer_enabled and time_remaining > 0:
		time_remaining -= delta
		if ui_hud:
			ui_hud.update_timer(time_remaining)
		
		if time_remaining <= 0:
			time_expired.emit()
			lose_game()

func register_player(p: Player):
	player = p
	player.health_changed.connect(_on_player_health_changed)
	player.sacrifice_applied.connect(_on_player_sacrifice_applied)

func register_ui_hud(hud: UIHud):
	ui_hud = hud

func register_vision_overlay(overlay: VisionOverlay):
	vision_overlay = overlay

func register_gate(gate: Gate):
	gates.append(gate)

func register_door(door: Door):
	doors.append(door)

func _on_player_health_changed(new_health: int):
	if ui_hud:
		ui_hud.update_health(new_health)
	
	if new_health <= 0:
		player_died.emit()
		lose_game()

func _on_player_sacrifice_applied(sacrifice_type: String):
	if ui_hud:
		ui_hud.add_sacrifice_indicator(sacrifice_type)
	
	if sacrifice_type == "vision" and vision_overlay:
		vision_overlay.update_vision_radius(player.vision_radius)

func win_game():
	if game_over:
		return
		
	game_over = true
	game_paused = true
	
	var completion_time = 120.0 - time_remaining
	if completion_time < best_time or best_time == 0.0:
		best_time = completion_time
		save_best_time()
	
	player_won.emit()
	if ui_hud:
		ui_hud.show_win_screen(completion_time, best_time)

func lose_game():
	if game_over:
		return
		
	game_over = true
	game_paused = true
	
	if ui_hud:
		ui_hud.show_lose_screen()

func restart_game():
	game_over = false
	game_paused = false
	time_remaining = 120.0
	
	# Reset player
	if player:
		player.reset_to_defaults()
	
	# Reset gates and doors
	for gate in gates:
		gate.reset()
	
	for door in doors:
		door.close()
	
	# Reset UI
	if ui_hud:
		ui_hud.reset()
	
	# Reset vision
	if vision_overlay:
		vision_overlay.update_vision_radius(player.vision_radius)

func pause_game():
	game_paused = true

func unpause_game():
	game_paused = false

func save_best_time():
	var config = ConfigFile.new()
	config.set_value("score", "best_time", best_time)
	config.save(config_file_path)

func load_best_time():
	var config = ConfigFile.new()
	var err = config.load(config_file_path)
	if err == OK:
		best_time = config.get_value("score", "best_time", 0.0)
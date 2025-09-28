class_name Gate
extends Area2D

@export var option_a: String = "health"
@export var option_b: String = "dir_left"
@export var option_a_text: String = "Sacrifice: -1 Heart"
@export var option_b_text: String = "Sacrifice: Disable Left"

var is_used: bool = false
var player_in_range: bool = false
var associated_door: Door

signal gate_activated(gate: Gate)

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	GameManager.register_gate(self)
	
	# Find the associated door based on gate name
	call_deferred("_find_door")

func _find_door():
	var door_name = ""
	if name == "Gate1":
		door_name = "Door1"
	elif name == "Gate2":
		door_name = "Door2"
	elif name == "Gate3":
		door_name = "Door3"
	
	if door_name != "":
		var doors_node = get_node("../../Doors")
		if doors_node and doors_node.has_node(door_name):
			associated_door = doors_node.get_node(door_name)

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
	
	# Open the associated door
	if associated_door:
		associated_door.open()
	
	# Disable this gate
	set_monitoring(false)

func reset():
	is_used = false
	player_in_range = false
	set_monitoring(true)
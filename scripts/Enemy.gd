class_name Enemy
extends CharacterBody2D

@export var patrol_points: Array[Vector2] = []
@export var speed: float = 50.0
@export var push_force: float = 300.0

var current_target_index: int = 0
var patrol_direction: int = 1

func _ready():
	if patrol_points.is_empty():
		# Default patrol points if none set
		patrol_points = [global_position - Vector2(50, 0), global_position + Vector2(50, 0)]

func _physics_process(delta):
	if patrol_points.size() < 2:
		return
	
	var target = patrol_points[current_target_index]
	var direction = (target - global_position).normalized()
	
	velocity = direction * speed
	move_and_slide()
	
	# Check if reached target
	if global_position.distance_to(target) < 10.0:
		current_target_index += patrol_direction
		
		# Reverse direction at ends
		if current_target_index >= patrol_points.size():
			current_target_index = patrol_points.size() - 2
			patrol_direction = -1
		elif current_target_index < 0:
			current_target_index = 1
			patrol_direction = 1

func _on_body_entered(body):
	if body is Player:
		# Push the player
		var push_direction = (body.global_position - global_position).normalized()
		body.velocity += push_direction * push_force
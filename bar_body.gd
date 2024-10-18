extends CharacterBody2D

@export var MoveSpeed = 100
@export var max_rotation = deg_to_rad(20) # Convert to radians immediately
@export var original_length = 1280

# Control nodes for left and right sides
var left_control: Marker2D
var right_control: Marker2D
var collision_shape: CollisionShape2D
var last_action = "nothing"

# Called when the node enters the scene tree for the first time.
func _ready():
	left_control = $left_control
	right_control = $right_control
	collision_shape = $BarCollider
	
	# Set initial positions for controls and the bar at 640px on the Y-axis
	left_control.position = Vector2(left_control.position.x, 640)
	right_control.position = Vector2(right_control.position.x, 640)
	position.y = 640

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_handle_input(delta)
	_update_bar()

# Moves control nodes based on input
func _handle_input(delta):
	_move_node(delta)

# Helper function to move a node up or down based on input
func _move_node(delta):
	var current_distance = left_control.position.distance_to(right_control.position)
	var max_distance = (original_length / cos(max_rotation))
	var move_amount = MoveSpeed * delta

	if current_distance <= max_distance:
		if Input.is_action_pressed("left_up"):
			left_control.position.y -= move_amount
			last_action = "left_up"
		if Input.is_action_pressed("left_down"):
			left_control.position.y += move_amount
			last_action = "left_down"
			
		if Input.is_action_pressed("right_up"):
			right_control.position.y -= move_amount
			last_action = "right_up"
		if Input.is_action_pressed("right_down"):
			right_control.position.y += move_amount
			last_action = "right_down"
	else:
		if last_action == "left_up":
			if Input.is_action_pressed("left_down"):
				left_control.position.y += move_amount
			if Input.is_action_pressed("right_up"):
				right_control.position.y -= move_amount
			
		if last_action == "left_down":
			if Input.is_action_pressed("left_up"):
				left_control.position.y -= move_amount
			if Input.is_action_pressed("right_up"):
				right_control.position.y -= move_amount
			
			
		if last_action == "right_up":
			if Input.is_action_pressed("left_up"):
						left_control.position.y -= move_amount
			if Input.is_action_pressed("right_down"):
				right_control.position.y += move_amount

		if last_action == "right_down":
			if Input.is_action_pressed("left_down"):
						left_control.position.y += move_amount
			if Input.is_action_pressed("right_up"):
				right_control.position.y -= move_amount
	print(last_action)
			
			

# Adjusts the bar's transformation to match the control points
func _update_bar():
	var midpoint = (left_control.position + right_control.position) / 2
	var distance = left_control.position.distance_to(right_control.position)
	var angle = (right_control.position - left_control.position).angle()

	print(distance)
	# Update the position, rotation, and scale of the bar
	position = midpoint
	rotation = clamp(angle, -max_rotation, max_rotation)
	scale.x = distance / original_length

	# Set the collision shape's properties to match the bar's properties
	collision_shape.position = Vector2() # Keep it centered relative to the bar
	collision_shape.rotation = 0         # Keep it unrotated relative to the bar
	collision_shape.scale.x = 1          # Ensure scale matches the original size

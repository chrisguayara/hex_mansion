extends CharacterBody2D


const SPEED = 15.0
const JUMP_VELOCITY = 2
@onready var animation_player: AnimationPlayer = $animations
var curr_state = "idle"
var state = "idle"
var last_anim = "down"
var last_direction = "down"
@onready var hand: Marker2D = $"Hand"
@onready var overworld_house: Node2D = $"../Overworld_House"



@export var ember : PackedScene
var curr_ember = null

var flares = []

@export var shoot_position : Node3D

func _physics_process(delta: float) -> void:
	
	
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	velocity = input_direction * SPEED 
	if input_direction != Vector2.ZERO:
		if abs(input_direction.x) > abs(input_direction.y):
			last_direction = "right" if input_direction.x > 0 else "left"
		else:
			last_direction = "down" if input_direction.y > 0 else "up"

		state = last_direction
	else:
		state = "idle_" + last_direction

	
	if animation_player.current_animation != state:
		animation_player.play(state)

	# Hand position fix
	if state == "up" or state == "idle_up":
		hand.position = Vector2(-0.12, 0.105)

	move_and_slide()
	
	


	move_and_slide()

extends CharacterBody3D


const SPEED = 2.0
const JUMP_VELOCITY = 2
@onready var animations: AnimationPlayer = $animations
var curr_state = "idle"
var state = "idle"
var last_anim = "down"

@onready var hand: Marker3D = $"Hand"
@onready var torch: Area3D = $"Hand/torch"
var can_attack = true
@onready var in_hand = "torch"
@export var ember : PackedScene
var curr_ember = null

var flares = []

@export var shoot_position : Node3D



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	
	if input_dir != Vector2.ZERO :
		
		if abs(input_dir.x) > abs(input_dir.y):
			state = "right" if input_dir.x > 0 else "left"
		else: 
			state = "down" if input_dir.y > 0 else "up"
		last_anim = state
	else:
		state = "idle_" + last_anim
		
	if animations.current_animation != state:
		animations.play(state)
	if state == "up" || "idle_up":
		hand.position = Vector3(-0.12,0.105,0)
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_just_pressed("control") and in_hand == "torch":
		
		var new_ember = ember.instantiate()
		flares.append(new_ember)
		get_parent().add_child(new_ember)
		new_ember.position = shoot_position.global_position
		new_ember.ember_direction = - get_global_transform().basis.z

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		pass
		
	move_and_slide()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "burning":
		curr_ember.queue_free()

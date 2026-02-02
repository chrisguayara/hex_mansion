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
var in_hand = "torch"
@onready var ember = $"../Ember"
var curr_ember = null





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
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_just_pressed("interact") and can_attack and in_hand == "torch":
		curr_ember = ember
		add_child(curr_ember)
		curr_ember.position = hand.global_position
		if curr_ember.has_node("AnimationPlayer"):
			curr_ember.AnimationPlayer.play("burning")



	move_and_slide()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "burning":
		curr_ember.queue_free()

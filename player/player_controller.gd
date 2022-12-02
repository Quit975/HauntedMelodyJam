extends CharacterBody3D

@onready var CameraPivot : Node3D = $CollisionShape3D/CameraPivot
@onready var Footsteps : FootstepPlayer = $Footsteps

const SPEED : float = 1.5
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_look_sensitivity : float = ProjectSettings.get_setting("player/mouse_look_sensitivity")
var gamepad_look_sensitivity : float = ProjectSettings.get_setting("player/gamepad_look_sensitivity")

var previous_position : Vector3;
var travelled_distance : float = 0.0;

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	previous_position = position;

func _physics_process(delta):
	process_movement(delta)
	handle_gamepad_look(delta)
	
func _input(event):
	if event is InputEventMouseMotion:
		handle_mouse_look(event)


# Movement functions
func process_movement(delta : float):
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir : Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)	
		
	var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	# Prevent super speed on diagonal movement but only at full speed not to lose analog info 
	if direction.length_squared() > 1:
		direction = direction.normalized()
		
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	update_footsteps()
	

func handle_mouse_look(event : InputEvent):
	var look_x : float = -event.relative.x * mouse_look_sensitivity * get_process_delta_time();
	var look_y : float = -event.relative.y * mouse_look_sensitivity * get_process_delta_time()
	apply_player_rotation(Vector2(look_x, look_y))

func handle_gamepad_look(delta : float):
	var look_vec : Vector2 = Input.get_vector(
		"look_left",
		"look_right",
		"look_up",
		"look_down"
	) * gamepad_look_sensitivity * delta

	# Prevent super speed on diagonal look but only at full speed not to lose analog info 
	if look_vec.length_squared() > 1:
		look_vec = look_vec.normalized()
		
	apply_player_rotation(look_vec * -1)
	
func apply_player_rotation(rotation_vec : Vector2):
	rotate_y(rotation_vec.x)
	CameraPivot.rotate_x(rotation_vec.y)
	CameraPivot.rotation.x = clamp(CameraPivot.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func update_footsteps():
	travelled_distance += (previous_position - position).length();
	
	if travelled_distance >= SPEED / 1.3:
		travelled_distance = 0.0;
		Footsteps.play_footstep();
		
	previous_position = position;

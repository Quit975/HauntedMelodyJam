extends RayCast3D
@tool
@export var ray_length : float = 2.0 : set = set_ray_length;

var last_traced_object : Object;
var current_interaction_area : InteractionArea;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_colliding():
		var collider : Object = get_collider();
		
		if last_traced_object and last_traced_object == collider:
			pass
			
		last_traced_object = collider;
		current_interaction_area = last_traced_object as InteractionArea;
	else:
		last_traced_object = null;
		current_interaction_area = null;

func set_ray_length(length : float):
	ray_length = length;
	set_target_position(Vector3(0.0, 0.0, -length)); 

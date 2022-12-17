class_name InteractionNode;
extends RayCast3D
@tool
@export var ray_length : float = 2.0 : set = set_ray_length;

var current_interaction_area : InteractionArea : set = set_current_interaction_area;
var is_enabled : bool = true : set = set_interaction_enabled;
var owner_agent : Node3D;

func _physics_process(_delta):
	if is_enabled:
		if is_colliding():
			var collider : Object = get_collider();
			
			current_interaction_area = collider as InteractionArea;
		else:
			current_interaction_area = null;

func interact():
	if current_interaction_area:
		current_interaction_area.on_interact(owner_agent);

func set_ray_length(length : float):
	ray_length = length;
	set_target_position(Vector3(0.0, 0.0, -length)); 
	
func set_current_interaction_area(area : InteractionArea):
	# we're changing the value so disable interaction before changing it
	if current_interaction_area and current_interaction_area != area:
		current_interaction_area.set_interaction_status(false);
		
	if area and area.is_interaction_enabled():
		current_interaction_area = area;
		current_interaction_area.set_interaction_status(true);
	else:
		current_interaction_area = null;

func set_interaction_enabled(set : bool):
	is_enabled = set;
	if !is_enabled and current_interaction_area:
		current_interaction_area.set_interaction_status(false);
		current_interaction_area = null;
		

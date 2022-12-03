class_name InteractionNode;
extends RayCast3D
@tool
@export var ray_length : float = 2.0 : set = set_ray_length;

var last_traced_object : Object;
var current_interaction_area : InteractionArea : set = set_current_interaction_area;
var is_enabled : bool = true : set = set_interaction_enabled;

func _physics_process(_delta):
	if is_enabled:
		if is_colliding():
			var collider : Object = get_collider();
			
			if last_traced_object and last_traced_object == collider:
				return;
				
			last_traced_object = collider;
			current_interaction_area = last_traced_object as InteractionArea;
		else:
			last_traced_object = null;
			current_interaction_area = null;

func interact():
	if current_interaction_area:
		current_interaction_area.on_interact();

func set_ray_length(length : float):
	ray_length = length;
	set_target_position(Vector3(0.0, 0.0, -length)); 
	
func set_current_interaction_area(area : InteractionArea):
	# it's the same, don't bother
	if current_interaction_area == area:
		return;
		
	# we're changing the value so disable interaction before changing it
	if current_interaction_area:
		current_interaction_area.set_interaction_status(false);
		
	current_interaction_area = area;
	
	# if we changed to another valid area, enable it
	if current_interaction_area:
		current_interaction_area.set_interaction_status(true);

func set_interaction_enabled(set : bool):
	is_enabled = set;
	if !is_enabled and current_interaction_area:
		current_interaction_area.set_interaction_status(false);
		last_traced_object = null;
		current_interaction_area = null;
		

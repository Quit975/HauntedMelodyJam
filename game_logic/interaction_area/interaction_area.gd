class_name InteractionArea;
extends Area3D

signal interaction_status_signal(is_interaction_enabled : bool);
signal interaction_triggered(interaction_agent : Node3D);

# is it possible to interact with
var interaction_enabled : bool = true;

# is player currently highlighting interaction
var interaction_available : bool = false;

var interaction_shape : CollisionObject3D;

func on_interact(agent : Node3D):
	interaction_triggered.emit(agent);
	
func set_interaction_status(status : bool):
	interaction_available = status;
	interaction_status_signal.emit(interaction_available);

func set_interaction_enabled(enabled : bool):
	interaction_enabled = enabled;
	if not interaction_enabled:
		set_interaction_status(false);
		
func is_interaction_enabled() -> bool:
	return interaction_enabled;

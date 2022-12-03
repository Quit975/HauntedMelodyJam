class_name InteractionArea;
extends Area3D
@tool

signal interaction_status_signal(is_interaction_enabled : bool);
signal interaction_triggered();

var interaction_available : bool = false;

@export var sphere_radius : float = 0.5 : set = set_interaction_radius;
var interaction_shape : SphereShape3D;

# Called when the node enters the scene tree for the first time.
func _ready():
	var coll_shape = get_node("CollisionShape3D");
	interaction_shape = coll_shape.shape as SphereShape3D;

func on_interact():
	interaction_triggered.emit();

func set_interaction_radius(radius : float):
	sphere_radius = radius;
	if interaction_shape:
		interaction_shape.radius = sphere_radius;
	
func set_interaction_status(status : bool):
	interaction_available = status;
	interaction_status_signal.emit(interaction_available);

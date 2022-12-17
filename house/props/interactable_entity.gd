class_name InteractableEntity
extends Node3D

@onready var Area : InteractionArea = $InteractionArea;
@onready var EntityMesh : MeshInstance3D = $StaticBody3D/Mesh;

@export var RequiredItem : Item;

func _ready():
	Area.interaction_status_signal.connect(on_interaction_status_changed);
	Area.interaction_triggered.connect(on_interaction_triggered);

func on_interaction_status_changed(status : bool):
	EntityMesh.set_instance_shader_parameter("enable", 1.0 if status else 0.0)

func on_interaction_triggered(interaction_agent : Node3D):
	print("interaction not implemented!");

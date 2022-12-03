class_name InteractableEntity
extends Node3D

@onready var Area : InteractionArea = $InteractionArea;
@onready var EntityMesh : MeshInstance3D = $StaticBody3D/Mesh;
@onready var InteractionShader : ShaderMaterial = $StaticBody3D/Mesh.get_active_material(0).next_pass;

func _ready():
	Area.interaction_status_signal.connect(on_interaction_status_changed);
	Area.interaction_triggered.connect(on_interaction_triggered);

func on_interaction_status_changed(status : bool):
	EntityMesh.set_instance_shader_parameter("enable", 1.0 if status else 0.0)

func on_interaction_triggered():
	print("interaction not implemented!");

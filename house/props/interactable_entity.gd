class_name InteractableEntity
extends Node3D

@onready var Area : InteractionArea = $InteractionArea;
@onready var EntityMesh : MeshInstance3D = $StaticBody3D/Mesh;
#var InteractionShader : ShaderMaterial = preload("res://house/interactable_shader.tres");
@onready var InteractionShader : ShaderMaterial = $StaticBody3D/Mesh.get_active_material(0).next_pass;

func _ready():
	Area.interaction_signal.connect(on_interaction_status_changed);
	#InteractionShader = EntityMesh.get_active_material(0).next_pass;

func on_interaction_status_changed(status : bool):
	EntityMesh.set_instance_shader_parameter("enable", 1.0 if status else 0.0)

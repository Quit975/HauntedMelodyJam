extends InteractableEntity

@onready var PianoMinigameScene : PackedScene = preload("res://melody/piano_minigame.tscn");

func on_interaction_triggered(interaction_agent : Node3D):
	get_tree().root.add_child(PianoMinigameScene.instantiate());

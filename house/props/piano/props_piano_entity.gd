extends InteractableEntity

@onready var PianoMinigameScene : PackedScene = preload("res://melody/piano_minigame.tscn");

func on_interaction_triggered():
	get_tree().root.add_child(PianoMinigameScene.instantiate());

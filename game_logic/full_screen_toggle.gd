# Godot 4 doesn't seem to have TestWidth and TestHeight settings anymore
# The purpose of this script is to add it to the root node of the starting scene
# So that in the full build the game starts in fullscreen

extends Node

func _enter_tree():
	if not OS.is_debug_build():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

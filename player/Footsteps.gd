class_name FootstepPlayer
extends AudioStreamPlayer3D

var sounds : Array[Resource] = []
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	sounds.append(preload("res://player/sfx/footsteps/footstep1.wav"))
	sounds.append(preload("res://player/sfx/footsteps/footstep2.wav"))
	sounds.append(preload("res://player/sfx/footsteps/footstep3.wav"))
	sounds.append(preload("res://player/sfx/footsteps/footstep4.wav"))


func play_footstep():
	sounds.shuffle();
	stream=sounds.front();
	pitch_scale = rng.randf_range(0.8, 1.2);
	play();

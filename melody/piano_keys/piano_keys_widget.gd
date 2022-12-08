class_name PianoKeysWidget
extends Control

@onready var lower_cover : ColorRect = $TextureRect/LowerCover;
@onready var mid_cover : ColorRect = $TextureRect/MidCover;
@onready var higher_cover : ColorRect = $TextureRect/HigherCover;

func _ready():
	show_mid();

func show_lower():
	lower_cover.visible = false;
	mid_cover.visible = true;
	higher_cover.visible = true;
	
func show_mid():
	lower_cover.visible = true;
	mid_cover.visible = false;
	higher_cover.visible = true;
	
func show_higher():
	lower_cover.visible = true;
	mid_cover.visible = true;
	higher_cover.visible = false;

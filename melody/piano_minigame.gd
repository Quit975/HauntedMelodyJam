extends Control

@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer;
@onready var free_timer : Timer = $FreeTimer;
@onready var player_ref : Player = get_tree().get_nodes_in_group("player")[0]

enum FirstPartSounds {
	F, Fs, Gs, As
}

const FIRST_PART : String = "first_part_sounds";

@onready var melody_sounds = {}

func _ready():
	melody_sounds = {
		FIRST_PART = {
			FirstPartSounds.F : preload("res://melody/sounds/first_part/Melody_FirstPart_F.wav"),
			FirstPartSounds.Fs : preload("res://melody/sounds/first_part/Melody_FirstPart_Fs.wav"),
			FirstPartSounds.Gs : preload("res://melody/sounds/first_part/Melody_FirstPart_Gs.wav"),
			FirstPartSounds.As : preload("res://melody/sounds/first_part/Melody_FirstPart_As.wav"),
		}
	}
	
	audio_player.volume_db = -5.0;
	
	player_ref.piano_input.connect(on_piano_key_pressed);
	player_ref.set_player_state(Player.PlayerState.PIANO);


func on_piano_key_pressed(action : StringName):
	match action:
		&"piano_up" : 
			play_piano_sound(self.melody_sounds.FIRST_PART[FirstPartSounds.F]);
		&"piano_down" : 
			play_piano_sound(self.melody_sounds.FIRST_PART[FirstPartSounds.Fs]);
		&"piano_left" : 
			play_piano_sound(self.melody_sounds.FIRST_PART[FirstPartSounds.Gs]);
		&"piano_right" :
			play_piano_sound(self.melody_sounds.FIRST_PART[FirstPartSounds.As]);
		&"back_action" :
			free_timer.timeout.connect(queue_free);
			free_timer.start();

func play_piano_sound(sound_resource : Resource):
	audio_player.stream = sound_resource;
	audio_player.play();

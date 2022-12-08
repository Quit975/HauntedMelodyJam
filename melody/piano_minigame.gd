extends Control

var audio_players : Array[AudioStreamPlayer];
@onready var free_timer : Timer = $FreeTimer;
@onready var player_ref : Player = get_tree().get_nodes_in_group("player")[0]
@onready var keys_widget : PianoKeysWidget = $PianoKeysRoot;

var current_player : int = 0;

enum FirstPartSounds {
	F, Fs, Gs, As
}

const FIRST_PART : String = "first_part_sounds";

@onready var melody_sounds = {}

enum PianoKeys {
	C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B
}

@onready var octave_keys = {
	PianoKeys.C : preload("res://melody/sounds/octave_keys/C.wav"),
	PianoKeys.Cs : preload("res://melody/sounds/octave_keys/Cs.wav"),
	PianoKeys.D : preload("res://melody/sounds/octave_keys/D.wav"),
	PianoKeys.Ds : preload("res://melody/sounds/octave_keys/Ds.wav"),
	PianoKeys.E : preload("res://melody/sounds/octave_keys/E.wav"),
	PianoKeys.F : preload("res://melody/sounds/octave_keys/F.wav"),
	PianoKeys.Fs : preload("res://melody/sounds/octave_keys/Fs.wav"),
	PianoKeys.G : preload("res://melody/sounds/octave_keys/G.wav"),
	PianoKeys.Gs : preload("res://melody/sounds/octave_keys/Gs.wav"),
	PianoKeys.A : preload("res://melody/sounds/octave_keys/A.wav"),
	PianoKeys.As : preload("res://melody/sounds/octave_keys/As.wav"),
	PianoKeys.B : preload("res://melody/sounds/octave_keys/B.wav"),
}

func _ready():
	melody_sounds = {
		FIRST_PART = {
			FirstPartSounds.F : preload("res://melody/sounds/first_part/Melody_FirstPart_F.wav"),
			FirstPartSounds.Fs : preload("res://melody/sounds/first_part/Melody_FirstPart_Fs.wav"),
			FirstPartSounds.Gs : preload("res://melody/sounds/first_part/Melody_FirstPart_Gs.wav"),
			FirstPartSounds.As : preload("res://melody/sounds/first_part/Melody_FirstPart_As.wav"),
		}
	}
	
	for player in $AudioPlayers.get_children():
		audio_players.push_back(player as AudioStreamPlayer);
	
	player_ref.piano_input.connect(on_piano_key_pressed);
	player_ref.set_player_state(Player.PlayerState.PIANO);

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		keys_widget.show_lower();
	elif Input.is_action_pressed("ui_right"):
		keys_widget.show_higher();
	else:
		keys_widget.show_mid();

func on_piano_key_pressed(action : StringName):
	match action:
		&"piano_left" : 
			if Input.is_action_pressed("ui_right"):
				play_piano_sound(self.octave_keys[PianoKeys.Gs]);
			elif Input.is_action_pressed("ui_left"):
				play_piano_sound(self.octave_keys[PianoKeys.C]);
			else:
				play_piano_sound(self.octave_keys[PianoKeys.E]);
		&"piano_up" : 
			if Input.is_action_pressed("ui_right"):
				play_piano_sound(self.octave_keys[PianoKeys.A]);
			elif Input.is_action_pressed("ui_left"):
				play_piano_sound(self.octave_keys[PianoKeys.Cs]);
			else:
				play_piano_sound(self.octave_keys[PianoKeys.F]);
		&"piano_right" :
			if Input.is_action_pressed("ui_right"):
				play_piano_sound(self.octave_keys[PianoKeys.As]);
			elif Input.is_action_pressed("ui_left"):
				play_piano_sound(self.octave_keys[PianoKeys.D]);
			else:
				play_piano_sound(self.octave_keys[PianoKeys.Fs]);
		&"piano_down" : 
			if Input.is_action_pressed("ui_right"):
				play_piano_sound(self.octave_keys[PianoKeys.B]);
			elif Input.is_action_pressed("ui_left"):
				play_piano_sound(self.octave_keys[PianoKeys.Ds]);
			else:
				play_piano_sound(self.octave_keys[PianoKeys.G]);
		&"back_action" :
			free_timer.timeout.connect(queue_free);
			free_timer.start();

func play_piano_sound(sound_resource : Resource):
	var player : AudioStreamPlayer = get_audio_player();
	player.volume_db = -5.0;
	player.stream = sound_resource;
	player.play();

func get_audio_player() -> AudioStreamPlayer:
	current_player += 1;
	if current_player > 3:
		current_player = 0;
		
	return audio_players[current_player];
	
	

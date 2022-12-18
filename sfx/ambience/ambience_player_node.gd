class_name AmbiencePlayer
extends Node3D

@onready var audio_player : AudioStreamPlayer3D = $AudioPlayer;
@onready var timer : Timer = $Timer;
var rng = RandomNumberGenerator.new()

const c_min_x : float = -8.0;
const c_max_x : float = 10.0;

const c_min_y : float = -1.1;
const c_max_y : float = 5;

const c_min_z : float = -11.0;
const c_max_z : float = 4;

@export var min_distance : float = 6.0;
@export var max_distance : float = 20.0;
@export var min_timer : float = 15.0;
@export var max_timer : float = 30.0;

var normal_sounds : Array[Resource];
var spook_sounds : Array[Resource];
@onready var piano_thud : Resource = preload("res://sfx/ambience/spook/special/PianoThud.wav");

var player_ref : Player;
var piano_ref : Node3D;
var spook_meter : float = 0.0;
var played_piano = false;

func _ready():
	player_ref = get_tree().get_nodes_in_group(&"player").front() as Player;
	piano_ref = get_tree().get_nodes_in_group(&"piano").front();
	load_resources_from_folder("res://sfx/ambience/normal/wood_creaks/", normal_sounds);
	load_resources_from_folder("res://sfx/ambience/spook/thuds/", spook_sounds);
	load_resources_from_folder("res://sfx/ambience/spook/scratches/", spook_sounds);
	timer.timeout.connect(play_sound);
	restart_timer();

func _process(delta):
	global_position = player_ref.global_position;
	
	spook_meter += delta / 60.0;
	
	print("Spook meter: " + str(spook_meter));

func play_sound():	
	if check_for_piano_spook():
		restart_timer();
		return;
			
	audio_player.global_position = calculate_random_sound_location();
	audio_player.stream = get_random_ambience_sound();
	adjust_sound_params();
	audio_player.play();
	restart_timer();
	
func calculate_random_sound_location() -> Vector3:
	var offset_vector : Vector3 = Vector3(
		0, 
		rng.randf_range(c_min_y, c_max_y), 
		rng.randf_range(min_distance, max_distance)
	);
	
	offset_vector = offset_vector.rotated(Vector3(0, 1, 0), rng.randf() * (2*PI));
	
	return global_position + offset_vector;
	
func get_random_ambience_sound() -> Resource:
	var random = rng.randf();
	if random > spook_meter:
		spook_sounds.shuffle();
		return spook_sounds.front();
	else:
		normal_sounds.shuffle();
		return normal_sounds.front();
	
func adjust_sound_params():
	audio_player.pitch_scale = rng.randf_range(0.85, 1.15);
	
func restart_timer():
	timer.start(rng.randf_range(min_timer, max_timer));
	
func load_resources_from_folder(path : String, container : Array[Resource]):
	var dir = DirAccess.open(path);
	dir.list_dir_begin();
	var sound = dir.get_next();
	while sound != "":
		if not sound.contains(".import"):
			sound = dir.get_next();
			continue;
		
		sound = sound.replace(".import", "");
		container.push_back(load(path + sound));
		sound = dir.get_next();

func check_for_piano_spook() -> bool:
	if played_piano or spook_meter < 0.6:
		return false;
	
	var piano_distance : float = global_position.distance_to(piano_ref.global_position);
	var is_on_different_floor : bool = abs(global_position.y - piano_ref.global_position.y) > 2.0;
	
	if piano_distance > 11.0 or is_on_different_floor:
		var piano_chance : float = rng.randf();
		if piano_chance > 0.8:
			play_piano_thud();
			played_piano = true;
			return true;
	
	return false;
	

func play_piano_thud():
	audio_player.global_position = piano_ref.global_position;
	audio_player.stream = piano_thud;
	audio_player.play();

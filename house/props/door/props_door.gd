extends InteractableEntity

enum DoorStatus {
	Unlocked,
	Locked,
	Sealed
}
	
var are_doors_opened : bool = false
@export var door_status : DoorStatus = DoorStatus.Unlocked
@onready var closed_rotation : Vector3 = self.rotation;
@onready var door_collider : StaticBody3D = $StaticBody3D;

func on_interaction_triggered(interaction_agent : Node3D):
	match door_status:
		DoorStatus.Sealed:
			pass;
		DoorStatus.Locked:
			if RequiredItem:
				var player : Player = interaction_agent as Player;
				if player:
					if player.Inventory.has_item(RequiredItem):
						door_status = DoorStatus.Unlocked;
						open_door(interaction_agent);
					else:
						print("I have no key");
						
		DoorStatus.Unlocked:
			if are_doors_opened:
				close_door();
			else:
				open_door(interaction_agent);

func open_door(opening_agent : Node3D):
	on_action_started();
	var direction : int = calculate_direction(opening_agent.global_position);
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE);
	tween.tween_property(
		self, 
		"rotation", 
		Vector3(0, PI * 0.5 * direction, 0),
		1.0).from_current().as_relative();
		
	tween.tween_callback(on_action_finished);
	
func close_door():
	on_action_started();
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE);
	tween.tween_property(self, "rotation", closed_rotation, 1.0);
	tween.tween_callback(on_action_finished);
	
func on_action_started():
	disable_collision();
	Area.set_interaction_enabled(false);
	
func on_action_finished():
	enable_collision();
	Area.set_interaction_enabled(true);
	are_doors_opened = not are_doors_opened;

func calculate_direction(agent_pos : Vector3) -> int:
	var checkpoint : Vector3 = Vector3(0, 0, 2);
	checkpoint = checkpoint.rotated(Vector3(0, 1, 0), global_rotation.y);
	checkpoint = global_position + checkpoint;
	
	var vec_to_agent : Vector3 = global_position - agent_pos;
	var vec_to_checkpoint :Vector3 = global_position - checkpoint;
	
	if vec_to_agent.dot(vec_to_checkpoint) < 0:
		return -1;
	else:
		return 1;

# collision disable/enable empty for now as it acutally feels better that way
func disable_collision():
	#door_collider.set_collision_layer_value(1, false);
	pass;
	
func enable_collision():
	#door_collider.set_collision_layer_value(1, true);
	pass;

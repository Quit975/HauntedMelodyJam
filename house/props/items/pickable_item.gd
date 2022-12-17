extends InteractableEntity

@export var item_resource : Item;

func on_interaction_triggered(interaction_agent : Node3D):
	if item_resource:
		var player : Player = interaction_agent as Player;
		if player:
			player.Inventory.add_item(item_resource);
			queue_free();

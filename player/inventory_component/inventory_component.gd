class_name InventoryNode
extends Node

var inventory_array : Array[Item];

func has_item(item : Item) -> bool:
	return inventory_array.count(item) > 0;

func add_item(item : Item):
	inventory_array.push_back(item);
	
func remove_item(item : Item):
	inventory_array.erase(item);

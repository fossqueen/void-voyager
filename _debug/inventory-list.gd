extends VBoxContainer

var item_scene = load("res://_debug/inventory-item.tscn")

func _ready():
	for item_unique_id in Global.save.player.inventory.items:
		print("wow")
		var new_item = item_scene.instance()
		add_child(new_item)
		print("yo")
		new_item.set_labels(item_unique_id, Global.save.player.inventory.get_amount(item_unique_id))


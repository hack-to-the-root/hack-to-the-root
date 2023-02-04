extends ScrollContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var yaml = preload("res://addons/godot-yaml/gdyaml.gdns").new()
	
	# add shop buttons
	var file = File.new()
	file.open("res://scenes/overworld/shop.yaml", File.READ)
	var shop_items = file.get_as_text()
	file.close()
	shop_items = yaml.parse(shop_items).result
	var shop_container = get_node("ShopVBox")
	for item in shop_items:
		var button = Button.new()
		button.set_size(Vector2(100, 50))
		button.text = item.display_name
		button.connect("pressed", self, "_buy_item", [ item ])
		shop_container.add_child(button)
		print("added button " + item.name + " with display_name " + item.display_name)
		print(button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _buy_item(item):
	print("bying " + item.name + " for " + str(item.costs) + " credits")
	Globals.money -= item.costs
	match item.name:
		"pizza": Globals.pizza += 1
		"coffee": Globals.coffee += 1

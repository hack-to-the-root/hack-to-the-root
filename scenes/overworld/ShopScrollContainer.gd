extends ScrollContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var yaml = preload("res://addons/godot-yaml/gdyaml.gdns").new()
	
	# add shop buttons
	var file = File.new()
	file.open("res://scenes/overworld/shop.yaml.tres", File.READ)
	var shop_items = file.get_as_text()
	file.close()
	shop_items = yaml.parse(shop_items).result
	var shop_container = get_node("ShopVBox")
	for item in shop_items:
		if item.has("hide") && item["hide"]:
			continue
		var button = Button.new()
		button.set_size(Vector2(100, 50))
		button.text = "$ " + str(item.costs) + " - " + item.display_name
		button.icon = load("res://assets/overworld/" + item.icon)
		button.connect("pressed", self, "_buy_item", [ button, item ])
		button.connect("mouse_entered", self, "_on_button_mouse_entered", [ item ])
		button.connect("mouse_exited", self, "_on_button_mouse_exited")
		
		if Globals.upgrades_out_of_stock.has(item.name):
			button.disabled = true
		
		shop_container.add_child(button)

func _on_button_mouse_entered(item):
	var label = get_parent().get_node("ShopLabel")
	label.text = item.description
	label.visible = true

func _on_button_mouse_exited():
	var label = get_parent().get_node("ShopLabel")
	label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _buy_item(button, item):
	print("buying " + item.name + " for " + str(item.costs) + " credits")
	# check for sufficient funds
	if item.costs > Globals.money:
		print("not enough money to buy item: " + item.name)
		return
	Globals.removeMoney(item.costs)
	match item.name:
		"pizza": Globals.addPizza(1)
		"coffee": Globals.addCoffee(1)
		_:
			Globals.upgrades.append(item)
			Globals.upgrades_out_of_stock.append(item.name)
			button.disabled = true

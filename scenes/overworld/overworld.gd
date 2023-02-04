extends Node

onready var money_label = get_node("VBoxContainer/GUI/GUIContainer/StatsContainer/MoneyContainer/Money/Background/Number")
onready var level_label = get_node("VBoxContainer/GUI/GUIContainer/StatsContainer/LevelContainer/Level/Background/Number")
onready var pizza_label = get_node("VBoxContainer/GUI/GUIContainer/FoodContainer/PizzaContainer/Pizza/Background/Number")
onready var coffee_label = get_node("VBoxContainer/GUI/GUIContainer/FoodContainer/CoffeeContainer/Coffee/Background/Number")


# Called when the node enters the scene tree for the first time.
func _ready():
	var yaml = preload("res://addons/godot-yaml/gdyaml.gdns").new()
	
	# add shop buttons
	var file = File.new()
	file.open("res://scenes/overworld/shop.yaml", File.READ)
	var shop_items = file.get_as_text()
	file.close()
	shop_items = yaml.parse(shop_items).result
	var shop_container = get_node("VBoxContainer/ShopScrollContainer/ShopVBox")
	for item in shop_items:
		var button = Button.new()
		button.set_size(Vector2(100, 50))
		button.text = item.display_name
		shop_container.add_child(button)
		print("added button " + item.name + " with display_name " + item.display_name)
		print(button)


func _process(delta):
	money_label.text = str(Globals.money)
	level_label.text = str(Globals.level)
	pizza_label.text = str(Globals.pizza)
	coffee_label.text = str(Globals.coffee)


func _on_AddMoneyButton_pressed():
	Globals.addMoney(100)


func _on_RemoveMoneyButton_pressed():
	Globals.removeMoney(100)


func _on_AddLevelButton_pressed():
	Globals.addLevel(1)


func _on_RemoveLevelButton_pressed():
	Globals.removeLevel(1)


func _on_AddPizzaButton_pressed():
	Globals.addPizza(1)


func _on_RemovePizzaButton_pressed():
	Globals.removePizza(1)


func _on_AddCoffeeButton_pressed():
	Globals.addCoffee(1)


func _on_RemoveCoffeeButton_pressed():
	Globals.removeCoffee(1)


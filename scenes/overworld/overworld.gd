extends Node

const COFFEE_CONSUMPTION_INTERVAL = 12.3
const COFFEE_CONSUMPTION_AMOUNT = 1

const PIZZA_CONSUMPTION_INTERVAL = 27.1
const PIZZA_CONSUMPTION_AMOUNT = 1

onready var money_label = get_node("VBoxContainer/GUI/GUIContainer/StatsContainer/MoneyContainer/Money/Background/Number")
onready var pizza_label = get_node("VBoxContainer/GUI/GUIContainer/FoodContainer/PizzaContainer/Pizza/Background/Number")
onready var coffee_label = get_node("VBoxContainer/GUI/GUIContainer/FoodContainer/CoffeeContainer/Coffee/Background/Number")

var time_since_coffee_consumption = 0
var time_since_pizza_consumption = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.initTasks()
	if !OS.is_debug_build():
		$VBoxContainer/GUI/GUIContainer/CheatContainer.hide()
	
	if Globals.taskOutcome == true:
		Globals.succeedTask()
	elif Globals.taskOutcome == false:
		Globals.failTask()
	
	Globals.loadButtonStates()


func _process(delta):
	money_label.text = str(Globals.money)
	
	pizza_label.text = "{pizza} (-{amount}/{interval}s)".format({
		"pizza": Globals.pizza,
		"amount": PIZZA_CONSUMPTION_AMOUNT,
		"interval": PIZZA_CONSUMPTION_INTERVAL
	})
	
	coffee_label.text = "{coffee} (-{amount}/{interval}s)".format({
		"coffee": Globals.coffee,
		"amount": COFFEE_CONSUMPTION_AMOUNT,
		"interval": COFFEE_CONSUMPTION_INTERVAL
	})
	
	consumeCoffeeAndPizzaIfNecessary(delta)
	checkStarvation()
	checkWinCondition()
	
	
func consumeCoffeeAndPizzaIfNecessary(delta):
	time_since_coffee_consumption += delta
	time_since_pizza_consumption += delta
	
	if time_since_coffee_consumption > COFFEE_CONSUMPTION_INTERVAL:
		time_since_coffee_consumption = 0
		$drinkingSound.play()
		Globals.removeCoffee(COFFEE_CONSUMPTION_AMOUNT)
		
	if time_since_pizza_consumption > PIZZA_CONSUMPTION_INTERVAL:
		time_since_pizza_consumption = 0
		$eatingSound.play()
		Globals.removePizza(PIZZA_CONSUMPTION_AMOUNT)

func checkStarvation():
	if Globals.pizza <= 0 || Globals.coffee <= 0:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/gameover/gameover.tscn")
		

func checkWinCondition():
	if Globals.progress['Server28']['finished']:
		yield(get_tree().create_timer(3.0), "timeout")
		get_tree().change_scene("res://scenes/completed/completed.tscn")


func _on_AddMoneyButton_pressed():
	Globals.addMoney(100)


func _on_RemoveMoneyButton_pressed():
	Globals.removeMoney(100)


func _on_AddPizzaButton_pressed():
	Globals.addPizza(1)


func _on_RemovePizzaButton_pressed():
	Globals.removePizza(1)


func _on_AddCoffeeButton_pressed():
	Globals.addCoffee(1)


func _on_RemoveCoffeeButton_pressed():
	Globals.removeCoffee(1)


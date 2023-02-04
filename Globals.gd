extends Node

var money = 1000
var level = 1
var pizza = 5
var coffee = 5
var upgrades = []
var task = {}

func addMoney(amount):
	money += amount


func removeMoney(amount):
	money -= amount


func addLevel(amount):
	level += amount


func removeLevel(amount):
	level -= amount


func addPizza(amount):
	pizza += amount


func removePizza(amount):
	pizza -= amount


func addCoffee(amount):
	coffee += amount


func removeCoffee(amount):
	coffee -= amount


func getTimeBonus():
	var time = 0
	for upgrade in upgrades:
		if upgrade.has("joker"):
			time += upgrade.time_bonus
	return time


func hasJoker():
	var joker = false
	for upgrade in upgrades:
		if upgrade.has("joker") && upgrade.joker:
			return upgrade.joker
	return false


func useJoker():
	for upgrade in upgrades:
		if upgrade.has("joker") && upgrade.joker:
			upgrades.erase(upgrade)
			break

extends Node

var money = 1000
var level = 1
var pizza = 5
var coffee = 5
var upgrades = []
var task = {}

var scriptKiddieTasks = []
var regexTasks = []
var questionTasks = []

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
		if upgrade.has("time_bonus"):
			time += upgrade.time_bonus
	return time


func hasFeature(feature):
	for upgrade in upgrades:
		if upgrade.name == feature:
			return true
		if upgrade.has(feature) && upgrade[feature]:
			return true
	return false


func useFeature(feature):
	if feature != "joker" && feature != "hint":
		return
	for upgrade in upgrades:
		if upgrade.has(feature) && upgrade[feature]:
			upgrades.erase(upgrade)
			break


func initTasks():
	if scriptKiddieTasks.empty() && regexTasks.empty() && questionTasks.empty():
		randomize()
		var yaml = preload("res://addons/godot-yaml/gdyaml.gdns").new()
		var file = File.new()
		file.open("res://scenes/hacking/config.yaml.tres", File.READ)
		var config = file.get_as_text()
		file.close()
		config = yaml.parse(config).result
		
		for c in config:
			match c['type']:
				'scriptkiddie':
					scriptKiddieTasks.append(c)
				'question':
					questionTasks.append(c)
				'regex':
					regexTasks.append(c)


func setScriptKiddieTask():
	task = scriptKiddieTasks[randi() % scriptKiddieTasks.size()]


func setRegexTask():
	task =  regexTasks[randi() % regexTasks.size()]


func setQuestionTask():
	task = questionTasks[randi() % questionTasks.size()]

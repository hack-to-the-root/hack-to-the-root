extends Node

var money = 0
var pizza = 5
var coffee = 5
var upgrades = []
var upgrades_out_of_stock = []
var task = {}

var taskOutcome = null
var currentPath = ""
var progressBasePath = "/root/Node2D/VBoxContainer/HBoxContainer2/ServersContainer/Control/"
var progress = {
	"Server1": {
		"finished": false,
		"enabled": true,
		"unlocks": [
			"Server4",
			"Server6"
		]
	},
	"Server2": {
		"finished": false,
		"enabled": true,
		"unlocks": [
			"Server4",
			"Server7"
		]
	},
	"Server3": {
		"finished": false,
		"enabled": true,
		"unlocks": [
			"Server8",
			"Server9"
		]
	},
	"Server4": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server11"
		]
	},
	"Server5": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server13"
		]
	},
	"Server6": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server5",
			"Server10",
			"Server11"
		]
	},
	"Server7": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server11"
		]
	},
	"Server8": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server12"
		]
	},
	"Server9": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server12",
			"Server16"
		]
	},
	"Server10": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server14"
		]
	},
	"Server11": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server12",
			"Server14"
		]
	},
	"Server12": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server14",
			"Server15"
		]
	},
	"Server13": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server17"
		]
	},
	"Server14": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server17",
			"Server15"
		]
	},
	"Server15": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server18"
		]
	},
	"Server16": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server18"
		]
	},
	"Server17": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server19"
		]
	},
	"Server18": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server19"
		]
	},
	"Server19": {
		"finished": false,
		"enabled": false,
		"unlocks": [
			"Server20"
		]
	},
	"Server20": {
		"finished": false,
		"enabled": false,
		"unlocks": [
		]
	},
}

var scriptKiddieTasks = []
var regexTasks = []
var questionTasks = []
var randomnessTasks = []

func setCurrentButton(path):
	currentPath = path.replace(progressBasePath, "");


func setTaskOutcome(outcome):
	taskOutcome = outcome


func loadButtonStates():
	for button in progress:
		get_node(progressBasePath + button).disabled = !progress[button]["enabled"]


func succeedTask():
	progress[currentPath]["finished"] = true
	progress[currentPath]["enabled"] = false

	for unlock in progress[currentPath]["unlocks"]:
		if !progress[unlock]["finished"]:
			progress[unlock]["enabled"] = true


func failTask():
	progress[currentPath]["finished"] = true
	progress[currentPath]["enabled"] = false


func addMoney(amount):
	money += amount


func removeMoney(amount):
	money -= amount


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
				'randomness':
					randomnessTasks.append(c)


func setScriptKiddieTask():
	task = scriptKiddieTasks[randi() % scriptKiddieTasks.size()]
	task['timeout'] += getTimeBonus()


func setRegexTask():
	task =  regexTasks[randi() % regexTasks.size()]
	task['attempts'] = 1
	task['timeout'] += getTimeBonus()
	
	if hasFeature("bruteforce"):
		task['attempts'] = -1
		

func setQuestionTask():
	task = questionTasks[randi() % questionTasks.size()]
	task['attempts'] = 1
	task['timeout'] += getTimeBonus()
	
	if hasFeature("bruteforce"):
		task['attempts'] = -1
		
	
func setRandomnessTask():
	task = randomnessTasks[randi() % randomnessTasks.size()]
	task['timeout'] += getTimeBonus()

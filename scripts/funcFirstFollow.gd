extends Node2D

var printString = ""
onready var txtFirst = get_node("txt_first")
onready var txtFollow = get_node("txt_follow")

func _ready():
	txtFirst.set_readonly(true)
	txtFirst.set_show_line_numbers(true)
	var dictionary = global.productionDictionary

	var keys = dictionary.keys()
	for key in keys:
		first_set(key, dictionary)
	txtFirst.set_text(printString)
	txtFollow.set_text("\n\n\n\t\t\t\t\t404\n\t\t\t\t\t  :(")
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_cancel"): get_tree().quit()

func first_set(key, dictionary):
	var first = ""
	var evaluatedProduction = dictionary[key]
	for item in evaluatedProduction:
		if (typeof(item) == TYPE_STRING):
			var splittedItem = Array(item.split(" "))
			if splittedItem.size() > 0:
				var index = 0
				while index != -1:
					index = splittedItem.find("")
					splittedItem.remove(index)
				# CM: Eval rule No.1 OR nule No.3
				if global.terminals.has(splittedItem[0]) || splittedItem[0] == str("e"):
					first += str(splittedItem[0], " , ")
				# CM: Eval rule No.2
				else:
					printString += str("Primero(", key, ")\t->\t ")
					first_set(splittedItem[0], dictionary)
		elif (typeof(item) == TYPE_STRING_ARRAY):
			# TODO-CM: handle StringArray to String
			pass
	if first != "":
		first = first.replace(" ", "")
		first = Array(first.split(","))
		first.erase("")
		for element in first:
			while true:
				var counter = first.count(element)
				if counter > 1:
					first.erase(element)
				else:
					break
		first = String(first)
		first = first.replace("[", "")
		first = first.replace("]", "")
		printString += str("Primero(", key, ")\t->  {  ", first, "  }\n")
		#printString += str("Primero(", key, ")\t->  {  ", first.substr(0, first.length()-3), "  }\n")

func follow_set():
	pass

func _on_btn_return_pressed():
	get_tree().change_scene("res://scenes/main.tscn")

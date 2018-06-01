extends Node2D

var printString = ""

func _ready():
	var dictionary = global.productionDictionary

	var label = get_node("New Scene")
	label.set_text(dictionary.to_json())
	var keys = dictionary.keys()
	for key in keys:
		first_set(key, dictionary)
	print(printString)
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
		printString += str("Primero(", key, ")\t->  {  ", first.substr(0, first.length()-3), "  }\n")

func follow_set():
	pass

func _on_btn_return_pressed():
	get_tree().change_scene("res://scenes/main.tscn")

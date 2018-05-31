extends Node2D

func _ready():
	var dictionary = global.productionDictionary
	#print(dictionary)

	var label = get_node("New Scene")
	label.set_text(dictionary.to_json())
	var keys = dictionary.keys()
	for key in keys:
		first_set(key, dictionary)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_cancel"): get_tree().quit()

func first_set(key, dictionary):
	var first = ""
	var evaluatedProduction = dictionary[key]
	for item in evaluatedProduction:
		var splittedItem = Array(item.split(" "))
		if splittedItem.size() > 0:
			var index = 0
			while index != -1:
				index = splittedItem.find("")
				splittedItem.remove(index)
			print(splittedItem)
			# CM: Eval rule No.1 OR nule No.3
			if validate_rule_one_three(splittedItem, first):
				pass
			# CM: Eval rule No.2
			else:
				# CM: call this function recursively
				pass
	print(str("Primero(", key, ")\t->\t ", first))
	
func validate_rule_one_three(splittedItem, first):
	if global.terminals.has(splittedItem[0]) || splittedItem[0] == str("e"):
		first += str(splittedItem[0], " ")
		return true

func follow_set():
	pass

func _on_btn_return_pressed():
	get_tree().change_scene("res://scenes/main.tscn")

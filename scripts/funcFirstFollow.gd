extends Node2D

func _ready():
	var dictionary = global.productionDictionary
	print(dictionary)

	var label = get_node("New Scene")
	label.set_text(dictionary.to_json())
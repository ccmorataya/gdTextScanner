extends Node2D

func _ready():
	var dictionary = global.productionDictionary
	print(dictionary)

	var label = get_node("New Scene")
	label.set_text(dictionary.to_json())
	print((dictionary.keys()))
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_cancel"): get_tree().quit()

func first():
	pass

func _on_btn_return_pressed():
	get_tree().change_scene("res://scenes/main.tscn")

extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var varColumn = get_node("txt_var")
	var constColumn = get_node("txt_const")
	varColumn.set_readonly(true)
	constColumn.set_readonly(true)
	pass


func _on_btn_select_pressed():
	var fd = get_node("fd_selectFile")
	fd.show()
	pass # replace with function body

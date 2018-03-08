extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var fd = get_node("fd_selectFile")
onready var path = get_node("ln_path")
onready var varColumn = get_node("txt_var")
onready var terminalColumn = get_node("txt_terminal")
onready var originalColumn = get_node("txt_original")

func _ready():
	fd.add_filter("*.txt")
	varColumn.set_readonly(true)
	terminalColumn.set_readonly(true)
	originalColumn.set_readonly(true)

func _on_btn_select_pressed():
	fd.show()

func _on_fd_selectFile_confirmed():
	var file = File.new()
	var fileName = str("res://", fd.get_current_file())
	path.set_text(fileName)
	file.open(fileName, file.READ)
	originalColumn.set_text(file.get_as_text())

func _on_fd_selectFile_file_selected( path ):
	_on_fd_selectFile_confirmed()

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
	var textFile = file.get_as_text()
	originalColumn.set_text(textFile)
	file.close()
	extractSymbols("\\w:", textFile, ":", varColumn)
	extractSymbols("'\\w+'", textFile, "", terminalColumn)
# TODO add terminales

func _on_fd_selectFile_file_selected( path ):
	_on_fd_selectFile_confirmed()

func extractSymbols(pattern, text, splitChar, columnToInsert):
	var regex = RegEx.new()
	regex.compile(pattern)
	var strArray = []
	var i = 0
	while regex.find(text, i) >= 0:
		i = regex.find(text, i) + 1
		strArray.append(str(regex.get_capture(0)))
# TODO remove duplicated variables in strArray
	print(str(pattern, " ", strArray))
	for single in strArray:
		var char = single.split(splitChar)[0]
		#print(typeof(char))
		if char.substr(0,1) == "\'":
			columnToInsert.insert_text_at_cursor(char.substr(1, char.length()-2))
		else:
			columnToInsert.insert_text_at_cursor(char)
		columnToInsert.insert_text_at_cursor("\n")
	pass
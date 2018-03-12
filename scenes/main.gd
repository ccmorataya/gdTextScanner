extends Node2D

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
	varColumn.set_text("")
	terminalColumn.set_text("")
	originalColumn.set_text("")
	fd.show()

func _on_fd_selectFile_confirmed():
	var file = File.new()
	print(fd.get_current_path())
	var fileName = fd.get_current_path()
	path.set_text(fileName)
	file.open(fileName, file.READ)
	var textFile = file.get_as_text()
	originalColumn.set_text(textFile)
	file.close()
	extractSymbols("\\w+:", textFile, ":", varColumn)
	extractSymbols("'\\w+'", textFile, "", terminalColumn)

func _on_fd_selectFile_file_selected( path ):
	_on_fd_selectFile_confirmed()

func extractSymbols(pattern, text, splitChar, columnToInsert):
	var regex = RegEx.new()
	regex.compile(pattern)
	var strArray = []
	var i = 0
	while regex.find(text, i) >= 0:
		if splitChar == ":":
			i = regex.find(text, i) + regex.get_capture(0).length()
		else:
			i = regex.find(text, i) + 1		# i = position of :
		strArray.append(str(regex.get_capture(0)))
	removeDuplicates(strArray)
	for single in strArray:
		var char = single.split(splitChar)[0] if typeof(single) != TYPE_NIL else ""
		if char.substr(0,1) == "\'":
			columnToInsert.insert_text_at_cursor(char.substr(1, char.length()-2))
		else:
			columnToInsert.insert_text_at_cursor(char)
		columnToInsert.insert_text_at_cursor("\n")
	pass

func removeDuplicates(strArray):
	var lenArray = strArray.size()
	if lenArray == 0:
		return 0
	elif lenArray == 1:
		return 1
	
	var tmpStrArray = []
	tmpStrArray.resize(strArray.size())
	var tmpIndex = 0
	for i in range(0, lenArray-1):
		if strArray[i] != strArray[i+1]:
			tmpStrArray[tmpIndex] = strArray[i]
			tmpIndex += 1
	
	tmpStrArray[tmpIndex] = strArray[lenArray-1]
	tmpIndex += 1
	for i in range (0, tmpStrArray.size()):
		strArray[i] = tmpStrArray[i]
	return tmpIndex
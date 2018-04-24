extends Node2D

onready var fd = get_node("fd_selectFile")
onready var path = get_node("ln_path")
onready var varColumn = get_node("txt_var")
onready var terminalColumn = get_node("txt_terminal")
onready var originalColumn = get_node("txt_original")
onready var productionColumn = get_node("txt_producciones")
var varText = []
var terminalText = []
var productionText = []

func _ready():
	#OS.set_window_fullscreen(true)
	fd.add_filter("*.txt")
	varColumn.set_readonly(true)
	terminalColumn.set_readonly(true)
	originalColumn.set_readonly(true)
	productionColumn.set_readonly(true)

func _on_btn_select_pressed():
	varColumn.set_text("")
	terminalColumn.set_text("")
	originalColumn.set_text("")
	productionColumn.set_text("")
	fd.popup()

func _on_fd_selectFile_confirmed():
	var file = File.new()
	var fileName = fd.get_current_path()
	path.set_text(fileName)
	file.open(fileName, file.READ)
	var textFile = file.get_as_text()
	originalColumn.set_text(textFile)
	file.close()
	extractSymbols("\\w+:", textFile, ":", varColumn)
	extractSymbols("'\\w+'", textFile, "", terminalColumn)
	productions(textFile, varText, productionColumn)
#	extractSymbols("\\w+", textFile, "", productionColumn)

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
	if (columnToInsert == varColumn):
		varText = strArray
	elif (columnToInsert == terminalColumn):
		terminalText = strArray
	elif (columnToInsert == productionColumn):
		productionText = strArray

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

func _on_Exit_pressed():
	get_tree().quit()

func productions(originalText, variables, columnToInsert):
	
	var splited = originalText.split("\n")
	for line in splited:
		print(line)
#	var dict = {}
#	var lines = []
#	var find = int()
#	var regex = RegEx.new()
#	regex.compile("(\r\n|\r|\n)")
#	while regex.find(originalText) > 0:
#		find = regex.find(originalText)
#		lines.append(originalText.substr(0, find))
#	print(lines)
#	for item in variables:
#		#CM: Scann originalText line by line
#		pass#print(item)
	
	"""
	Format to print:
		S -> a
		S -> b
		S -> SS
	"""
	pass

#CM-TODO remove special chars like : and ' from String Array and reimplement in extractSymbols: splitChar
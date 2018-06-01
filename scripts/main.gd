extends Node2D

onready var fd = get_node("fd_selectFile")
onready var path = get_node("ln_path")
onready var varColumn = get_node("txt_var")
onready var terminalColumn = get_node("txt_terminal")
onready var originalColumn = get_node("txt_original")
onready var productionColumn = get_node("txt_producciones")
var varText = []
var terminalText = []

func _ready():
	#OS.set_window_fullscreen(true)
	global.productionDictionary = {}
	fd.add_filter("*.txt")
	varColumn.set_readonly(true)
	terminalColumn.set_readonly(true)
	originalColumn.set_readonly(true)
	productionColumn.set_readonly(true)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_cancel"): _on_Exit_pressed()

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
	extractSymbols("'\\S+'", textFile, "", terminalColumn)
	productions(textFile, productionColumn)
	varColumn.set_show_line_numbers(true)
	terminalColumn.set_show_line_numbers(true)
	productionColumn.set_show_line_numbers(true)
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
	columnToInsert.set_text(columnToInsert.get_text().strip_edges())

func removeDuplicates(strArray):
	var lenArray = strArray.size()
	if lenArray == 0:
		return 0
	elif lenArray == 1:
		return 1
	
	for element in strArray:
		while true:
			var counter = strArray.count(element)
			if counter > 1:
				strArray.erase(element)
			else:
				break

func _on_Exit_pressed():
	get_tree().quit()

func productions(originalText, columnToInsert):
	var splited = originalText.split("\n")
	for line in splited:
		var left = ""
		var right = ""
		var leftRegex = RegEx.new()
		leftRegex.compile("\\w+:")
		leftRegex.find(line)
		left = leftRegex.get_capture(0)
		left = left.replace(":", "\t->")
		
		var rightRegex = RegEx.new()
		rightRegex.compile("((?!\\s+:) .\\s.+)|((?!\\S+:) .\\S.+)")
		var rightIndex = rightRegex.find(line)
		right = line.substr(rightIndex, line.length())
		right = str(" ", right) if right == "e" else right
		var innerSplit = right.split("|")
		for rightItem in innerSplit:
			rightItem = rightItem.replace("\'", "")
			line = str(left, rightItem)
			columnToInsert.insert_text_at_cursor((str(line, "\n")))
		build_dict(left, right)
	columnToInsert.set_text(columnToInsert.get_text().strip_edges())
	global.variables = varText
	global.terminals = terminalText

func build_dict(left, right):
	# CM: transform the originalText to global.productionDictionary
	left = left.replace("\t->", "")
	right = right.split("|")
	if !global.productionDictionary.has(left):
		global.productionDictionary[left] = right
	else:
		global.productionDictionary[left] = [global.productionDictionary[left], right] #str(global.productionDictionary[left], " | ", right)
	global.productionDictionary.erase("")

func _on_btnContinue_pressed():
		get_tree().change_scene("res://scenes/funcFirstFollow.tscn")

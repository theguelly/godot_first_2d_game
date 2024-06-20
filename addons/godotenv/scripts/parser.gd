# dotenv parser class
# Author: Nik Mirza
# Updated/Fixed for Godot 4 By: theguelly
# Email: nik96mirza[at]gmail.com
class_name GodotEnv_Parser

var file: FileAccess
var env: Dictionary
var line: String
var row_contents: Array

func _init():
	pass
	
func parse(filename):
	if(not FileAccess.file_exists(filename)):
		return {};
	
	file = FileAccess.open(filename, FileAccess.READ)
	
	env = {};
	line = "";
	
	while !file.eof_reached():
		line = file.get_line();
		row_contents = line.split("=");
		env[row_contents[0]] = row_contents[1].lstrip("\"").rstrip("\"");
	return env;

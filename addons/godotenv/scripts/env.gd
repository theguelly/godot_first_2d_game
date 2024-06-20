# GodotEnv Singleton
# Author: Nik Mirza
# Updated/Fixed for Godot 4 By: theguelly
# Email: nik96mirza[at]gmail.com
extends Node

@onready var parser = GodotEnv_Parser.new();
var env = {};

func _ready():
	env = parser.parse("res://.env");
	
func get_env(name):
	# Prioritizing to fetch OS Environment Variables
	if(OS.has_environment(name)):
		return OS.get_environment(name);
		
	if(env.has(name)):
		return env[name];
		
	# Fallback value when env entry not found
	return "";

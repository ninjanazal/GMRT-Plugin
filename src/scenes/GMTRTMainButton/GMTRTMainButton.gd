tool
extends Control

onready var _comp : Dictionary = {
	"btn" : get_node("HBoxContainer/Button")
};

func connect_press(target, func_name: String):
	_comp.btn.connect("pressed", target, func_name);
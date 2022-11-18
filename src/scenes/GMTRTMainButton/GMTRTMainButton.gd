tool
extends Control


var _plug : EditorPlugin = null;

var _view : Dictionary = {
	"board" : preload("res://addons/GMRT-Plugin/view/mainview.tscn").instance()
};

onready var _comp : Dictionary = {
	"btn" : get_node("HBoxContainer/Button")
};

func setup(plug):
	_plug = plug;
	_comp.btn.connect("pressed", self, "_on_button_press");

func on_exit_tree():
	if(_view.board.is_inside_tree()):
		_plug.remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, _view.board);
	_view.board.free();

func _on_button_press():
	if(!_view.board.is_inside_tree()):
		_plug.add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, _view.board);
	else:
		_plug.remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, _view.board);
	

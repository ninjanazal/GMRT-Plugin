tool
extends EditorPlugin

var gmrtcore;
var _view_ : Node;

func _enter_tree():
	gmrtcore = preload("res://addons/GMRT-Plugin/src/gmrtcore.gd").new(self);
	_view_ = preload("res://addons/GMRT-Plugin/view/GMRTMainButton.tscn").instance();
	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, _view_);

func _exit_tree():
	remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, _view_);
	_view_.free();
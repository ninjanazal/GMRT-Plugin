tool
extends EditorPlugin

var _views : Dictionary = {
	"gmtk_btn" : preload("res://addons/GMRT-Plugin/view/GMRTMainButton.tscn").instance(),
	"board" : preload("res://addons/GMRT-Plugin/view/mainview.tscn").instance()
};


# - - - - - - - - - - - - - - -
# Godot API Functions
# - - - - - - - - - - - - - - -
func _enter_tree():
	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, _views.gmtk_btn);
	_views.gmtk_btn.connect_press(self, "_on_pressed");

func _exit_tree():
	if(_views.gmtk_btn.is_inside_tree()):
		remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, _views.gmtk_btn);
	_views.gmtk_btn.free();

# - - - - - - - - - - - - - - -
func _on_pressed():
	print(_views.board.is_inside_tree());
	if(!_views.board.is_inside_tree()):
		add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, _views.board);
	else:
		remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, _views.board);
	
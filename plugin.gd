tool
extends EditorPlugin

var _view : Dictionary = {
	"gmtk_btn" : preload("res://addons/GMRT-Plugin/view/GMRTMainButton.tscn").instance(),
};


# - - - - - - - - - - - - - - -
# Godot API Functions
# - - - - - - - - - - - - - - -
func _enter_tree():
	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, _view.gmtk_btn);
	_view.gmtk_btn.setup(self);

func _exit_tree():
	if(_view.gmtk_btn.is_inside_tree()):
		remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, _view.gmtk_btn);
	_view.gmtk_btn.on_exit_tree();
	_view.gmtk_btn.free();
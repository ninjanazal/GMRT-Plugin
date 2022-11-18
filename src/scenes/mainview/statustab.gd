tool
extends Tabs

# - - - - - - - - - - - - - - - -
# Class Status Entry
class StatusEntry:
	var _ref: Control = null;
	var _btn: Button = null;

	func _init(baseRef: Control):
		print("CREATING")
		_ref = baseRef;
		__find_button_on__(_ref);

	func set_button_pressed(val: bool):
		if(_btn != null):
			_btn.pressed = val;

	func connect_pressed(target: Object, funcName: String):
		if(_btn != null):
			_btn.connect("pressed", target, funcName);
		
	func __find_button_on__(root: Node):
		for child in root.get_children():
			if(child is Button):
				_btn = child;
				return;
			if(child.get_child_count() != 0):
				__find_button_on__(child);
# - - - - - - - - - - - - - - - -


export (NodePath) var base_viewport_cont = null;
export (NodePath) var strech_mode_cont = null;
export (NodePath) var strech_aspect_cont = null;
export (NodePath) var handheld_cont = null;
export (NodePath) var gpupixel_snap_cont = null;
export (NodePath) var vertexcolor_batching_cont = null;


var _elms : Dictionary = {
	"viewportSize" : null,
	"strechmode" : null,
	"strechaspect" : null,
	"handheld" : null,
	"gpupixelsnap" : null,
	"vertexcolorbatching" : null
}

# - - - - - - - - - - - - - - - -
# API override functions
func _enter_tree():
	var _nPaths = [base_viewport_cont, strech_mode_cont, strech_aspect_cont,
		handheld_cont, gpupixel_snap_cont, vertexcolor_batching_cont];
	for i in _nPaths.size():
		var tmp = get_node_or_null(_nPaths[i]);
		if(tmp != null):
			_elms[_elms.keys()[i]] = StatusEntry.new(tmp);
	_eval_project_state();


func _exit_tree():
	_elms.clear();
# - - - - - - - - - - - - - - - -

func _eval_project_state():
	_eval_viewport_size();


func _eval_viewport_size():
	var h = ProjectSettings.get_setting("display/window/size/height");
	var w = ProjectSettings.get_setting("display/window/size/width");

	_elms.viewportSize.set_button_pressed(h == w);

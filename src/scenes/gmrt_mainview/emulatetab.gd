tool
extends Control

export (NodePath) var enable_button = null;
export (NodePath) var ratio_spin = null;

var _elms: Dictionary = {
	"enable_btn" : null,
	"ratio_spin" : null
}

# - - - - - - - - - - - - - - - -
# API override functions
func _enter_tree():
	var _nPaths = [enable_button, ratio_spin];
	for i in _nPaths.size():
		var tmp = get_node_or_null(_nPaths[i]);
		if(tmp != null):
			_elms[_elms.keys()[i]] = tmp;
	
	_generate_connections();

# Godot API ready override function
func _ready():
	_on_enable_press(false);

# Godot API _exit_tree override function
func _exit_tree():
	_clear_connections();
	for i in _elms.size():
		_elms[_elms.keys()[i]] = null;
# - - - - - - - - - - - - - - - -

# Creats connections for the needed functionality
func _generate_connections():
	self.connect("visibility_changed", self, "_on_visibility_change");
	if(_elms.enable_btn != null): _elms.enable_btn.connect("toggled", self, "_on_enable_press");
	if(_elms.ratio_spin != null): _elms.ratio_spin.connect("value_changed", self, "_on_slider_change");

# Clears created connections
func _clear_connections():
	self.disconnect("visibility_changed", self, "_on_visibility_change");
	if(_elms.enable_btn != null): _elms.enable_btn.disconnect("toggled", self, "_on_enable_press");
	if(_elms.ratio_spin != null): _elms.ratio_spin.disconnect("value_changed", self, "_on_slider_change");

# On Object visible state change callback
func _on_visibility_change():
	if(!visible):
		_elms.enable_btn.set_pressed(false);

# On Enable emulation button toggle
# @pressed {bool}: Current toggle state
func _on_enable_press(pressed: bool):
	_elms.ratio_spin.set_value(1.0);
	_elms.ratio_spin.set_editable(pressed);

# On slider value change callback function
# @value {float}: New value
func _on_slider_change(value: float):
	var tSize = GmrtCore.BASE_SIZE;
	if(value < 1.0):
		if(value == 0.0): tSize.y = int((1.0 / 0.01) * tSize.y);
		else: tSize.y = int((1.0 / value) * tSize.y);
	elif(value > 1.0):
		tSize.x = int(value * tSize.x);
	
	ProjectSettings.set_setting("display/window/size/width", tSize.x);
	ProjectSettings.set_setting("display/window/size/height", tSize.y);
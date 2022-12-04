tool
extends Control

export (NodePath) var enable_button = null;
export (NodePath) var ratio_spin = null;
export (NodePath) var x_spin = null;
export (NodePath) var y_spin = null;

var _elms: Dictionary = {
	"enable_btn" : null,
	"ratio_spin" : null,
	"x_spin" : null,
	"y_spin" : null
}

# - - - - - - - - - - - - - - - -
# API override functions
func _enter_tree():
	var _nPaths = [enable_button, ratio_spin, x_spin, y_spin];
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
	if(_elms.x_spin != null): _elms.x_spin.connect("value_changed", self, "_on_spin_x_change");
	if(_elms.y_spin != null): _elms.y_spin.connect("value_changed", self, "_on_spin_y_change");

# Clears created connections
func _clear_connections():
	self.disconnect("visibility_changed", self, "_on_visibility_change");
	if(_elms.enable_btn != null): _elms.enable_btn.disconnect("toggled", self, "_on_enable_press");
	if(_elms.ratio_spin != null): _elms.ratio_spin.disconnect("value_changed", self, "_on_slider_change");
	if(_elms.x_spin != null): _elms.y_spin.disconnect("value_changed", self, "_on_spin_x_change");
	if(_elms.y_spin != null): _elms.y_spin.disconnect("value_changed", self, "_on_spin_y_change");

# On Object visible state change callback
func _on_visibility_change():
	if(!visible):
		_elms.enable_btn.set_pressed(false);
	else:
		_elms.x_spin.set_value(ProjectSettings.get_setting("display/window/size/width"));
		_elms.y_spin.set_value(ProjectSettings.get_setting("display/window/size/height"));

# On Enable emulation button toggle
# @pressed {bool}: Current toggle state
func _on_enable_press(pressed: bool):
	_elms.ratio_spin.set_value(1.0);
	_elms.ratio_spin.set_editable(pressed);

	_on_slider_change(_elms.ratio_spin.get_value());

# On slider value change callback function
# @value {float}: New value
func _on_slider_change(value: float):
	var tSize = Vector2(512, 512);
	var gmrtSingle = null;
	if(Engine.has_singleton("Gmrtcore")):
		gmrtSingle = Engine.get_singleton("Gmrtcore");
		tSize = gmrtSingle.BASE_SIZE;

	if(value < 1.0):
		if(value == 0.0): tSize.y = int((1.0 / 0.01) * tSize.y);
		else: tSize.y = int((1.0 / value) * tSize.y);
	elif(value > 1.0):
		tSize.x = int(value * tSize.x);
	
	if(_elms.x_spin.get_value() != tSize.x):
		_elms.x_spin.set_value(tSize.x);
	if(_elms.y_spin.get_value() != tSize.y):
		_elms.y_spin.set_value(tSize.y);

	ProjectSettings.set_setting("display/window/size/width", tSize.x);
	ProjectSettings.set_setting("display/window/size/height", tSize.y);

# On Spinner value change callback
# @value {float}: Current spin value
func _on_spin_x_change(value: float):
	var tmpRatio = 0;
	if(value != 0 && _elms.y_spin.get_value() != 0):
		tmpRatio = float(value / _elms.y_spin.get_value());
	
	if(_elms.ratio_spin.get_value() != tmpRatio):
		_elms.ratio_spin.set_value(tmpRatio);

# On Spinner value change callback
# @value {float}: current spin value
func _on_spin_y_change(value: float):
	var tmpRatio = 0;
	if(value != 0 && _elms.x_spin.get_value() != 0):
		tmpRatio = float(_elms.x_spin.get_value() / value);

	if(_elms.ratio_spin.get_value() != tmpRatio):
		_elms.ratio_spin.set_value(tmpRatio);
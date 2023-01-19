tool
extends Node

# - - - - - - - - - - - - - - -
enum CONDITIONTYPE {  TYPE_BOOL = 1, TYPE_INT, TYPE_REAL, TYPE_STRING, TYPE_LAYOUT }

# - - - - - - - - - - - - - - -
enum LAYOUT_TYPE { DEFAULT, DESKTOP, MOBILE, MOBILE_RIGHT, MOBILE_LEFT}

# Base project view size
var BASE_SIZE: Vector2 = Vector2(512, 512);


var _condition_list
var _current_size : Vector2 = Vector2.ZERO;
var _registed_scalers : Array = [];


# ==================== ====================
# GODOT API Override
# ==================== ====================

# - - - - - - - - - - - - - - -
func _enter_tree():
	if(Engine.is_editor_hint()):
		#ignore-warning:return_value_discarded
		ProjectSettings.connect("project_settings_changed", self, "_on_projectsettings_change");
		_on_projectsettings_change();
	else:
		#ignore-warning:return_value_discarded
		get_tree().root.connect("size_changed", self, "_on_viewsize_change");
		_on_viewsize_change();


# ==================== ====================
# PUBLIC
# ==================== ====================

# - - - - - - - - - - - - - - -
# Regists a scale animation
# @player {ScaleAnimation}: Animation player
func regist_scale_animation(player: ScaleAnimation):
	if(_registed_scalers.has(player)): return;
	_registed_scalers.append(player);
	
	var tmp :float = _current_size.x / _current_size.y;
	player.on_viewsize_change(tmp);


# - - - - - - - - - - - - - - -
# Unregists a scale animation
#
func unregist_scale_animation(player : ScaleAnimation):
	if(!_registed_scalers.has(player)): return;
	_registed_scalers.erase(player);



# ==================== ====================
# PRIVATE
# ==================== ====================

# - - - - - - - - - - - - - - -
func _on_viewsize_change():
	var rootView = get_tree().root as Viewport;
	_current_size = rootView.get_size_override();
	_call_size_change(_current_size);


# - - - - - - - - - - - - - - -
# On changing size, will trigger all the ScalaPlayers to update
func _call_size_change(size: Vector2):
	var tmp :float = size.x / size.y;
	for callable in _registed_scalers:
		callable.on_viewsize_change(tmp);




# ==================== ====================
# TOOL
# ==================== ====================
var _editor_plug  = null;

func set_plugin(plug): _editor_plug = plug;
func get_plugin(): 
	return _editor_plug;

# Builds the current size based on the current project setting
func _on_projectsettings_change():
	_current_size = Vector2(
		ProjectSettings.get_setting("display/window/size/width"),
		ProjectSettings.get_setting("display/window/size/height")
	);

	_call_size_change(_current_size);



func _get_property_list():
	return [{
		"name" : "base_size",
		"type" : TYPE_VECTOR2,
		"usage" : PROPERTY_USAGE_STORAGE
	}];
func _get(property):
	var value = null;
	match property:
		"base_size": value = BASE_SIZE;
	return value;

func _set(property, value):
	var value_set = true;
	match property:
		"base_size": BASE_SIZE = value;
		_: value_set = false;
	return value_set;
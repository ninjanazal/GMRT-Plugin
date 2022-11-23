tool
extends Node

var _current_size : Vector2 = Vector2.ZERO;
var _registed_scalers : Array = [];

# Regists a scale animation
# @player {ScaleAnimation}: Animation player
func regist_scale_animation(player: ScaleAnimation):
	if(_registed_scalers.has(player)): return;
	_registed_scalers.append(player);
	
	var tmp :float = _current_size.x / _current_size.y;
	player.on_viewsize_change(tmp);

# Unregists a scale animation
#
func unregist_scale_animation(player : ScaleAnimation):
	if(!_registed_scalers.has(player)): return;
	_registed_scalers.erase(player);


func _enter_tree():
	if(Engine.is_editor_hint()):
		#ignore-warning:return_value_discarded
		ProjectSettings.connect("project_settings_changed", self, "_on_projectsettings_change");
		_on_projectsettings_change();
	else:
		#ignore-warning:return_value_discarded
		get_tree().root.connect("size_changed", self, "_on_viewsize_change");
		_on_viewsize_change();


func _on_viewsize_change():
	var rootView = get_tree().root as Viewport;
	_current_size = rootView.get_size_override();
	print(rootView.size);

# On changing size, will trigger all the ScalaPlayers to update
func _call_size_change(size: Vector2):
	var tmp :float = size.x / size.y;
	for callable in _registed_scalers:
		callable.on_viewsize_change(tmp);

# - - - - - - - - - - - - - - -
# Tool
# Builds the current size based on the current project setting
func _on_projectsettings_change():
	_current_size = Vector2(
		ProjectSettings.get_setting("display/window/size/height"),
		ProjectSettings.get_setting("display/window/size/width")
	);

	_call_size_change(_current_size);
tool
extends Node

var _current_size : Vector2 = Vector2.ZERO;
var _registed_scalers : Array = [];

func regist_scale_animation(player: ScaleAnimation):
	if(_registed_scalers.has(player)):
		pass;


func _enter_tree():
	if(Engine.is_editor_hint()):
		#ignore-warning:return_value_discarded
		ProjectSettings.connect("project_settings_changed", self, "_on_projectsettings_change");
	else:
		#ignore-warning:return_value_discarded
		get_tree().root.connect("size_changed", self, "_on_viewsize_change");


func _on_viewsize_change():
	pass;

func _call_size_change(size: Vector2):
	pass;

# - - - - - - - - - - - - - - -
# Tool
# Builds the current size based on the current project setting
func _on_projectsettings_change():
	_current_size = Vector2(
		ProjectSettings.get_setting("display/window/size/height"),
		ProjectSettings.get_setting("display/window/size/width")
	);
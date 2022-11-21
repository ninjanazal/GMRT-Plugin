tool
extends EditorPlugin

var _view : Dictionary = {
	"main" : preload("res://addons/GMRT-Plugin/view/gmrt_mainview.tscn").instance()
};


# - - - - - - - - - - - - - - -
# Godot API Functions
# - - - - - - - - - - - - - - -
# Godot entre tree override
func _enter_tree():
	_view.main.visible = false;
	get_editor_interface().get_editor_viewport().add_child(_view.main);

# Godot on exit tree override
func _exit_tree():
	if(_view.main):
		_view.main.queue_free();

# Godot APi override
# Returns true if this is a main screen editor plugin 
# (it goes in the workspace selector together with 2D, 3D, Script and AssetLib)
func has_main_screen(): return true;

# Godot API override
# This function will be called when the editor is requested to become visible.
# It is used for plugins that edit a specific object type
func make_visible(visible):
	print("Request visible with %s" % visible);
	if(_view.main):
		_view.main.visible = visible;

# Godot API Override
# Override this method in your plugin to provide the name of the plugin when displayed in the Godot editor.
# For main screen plugins, this appears at the top of the screen,
# to the right of the "2D", "3D", "Script", and "AssetLib" buttons.
func get_plugin_name(): return "GMRT";

# Godot API override
# Override this method in your plugin to return a Texture in order to give it an icon.
# For main screen plugins, this appears at the top of the screen,
# to the right of the "2D", "3D", "Script", and "AssetLib" buttons.
# Ideally, the plugin icon should be white with a transparent background and 16x16 pixels in size.
func get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("ToolAddNode", "EditorIcons");
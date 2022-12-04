tool
extends EditorPlugin

var _view : Dictionary = {
	"button" : preload("res://addons/GMRT-Plugin/view/gmrt_btn.tscn").instance(),
	"main" : preload("res://addons/GMRT-Plugin/view/gmrt_mainview.tscn").instance(),
	"sep" : null,
	# Script Singleton
	"gmrtcore_path" : "res://addons/GMRT-Plugin/src/gmrtcore.gd"
};

# - - - - - - - - - - - - - - -
# Godot API Functions
# - - - - - - - - - - - - - - -
# Godot entre tree override
func _enter_tree():
	if(!_view.button.is_connected("pressed", self, "_on_button_press")):
		_view.button.connect("pressed", self, "_on_button_press");

	_view.sep = VSeparator.new();
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, _view.sep);
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, _view.button);

	_view.main.visible = false;
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, _view.main);


# Godot on exit tree override
func _exit_tree():
	if(_view.main):
		remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, _view.main);
		_view.main.queue_free();
	if(_view.button):
		if(_view.button.is_connected("pressed", self, "_on_button_press")):
			_view.button.disconnect("pressed", self, "_on_button_press")
		remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, _view.button);
		remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, _view.sep);
		_view.button.queue_free();
		_view.sep.queue_free();

# Godot APi override
# Returns true if this is a main screen editor plugin 
# (it goes in the workspace selector together with 2D, 3D, Script and AssetLib)
func has_main_screen(): return false;

# Godot API override
# This function will be called when the editor is requested to become visible.
# It is used for plugins that edit a specific object type
func make_visible(visible):
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

# On GMRT button press callback
func _on_button_press():
	make_visible(!_view.main.visible);
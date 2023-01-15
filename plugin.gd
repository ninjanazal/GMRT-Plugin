tool
extends EditorPlugin

var _view : Dictionary = {
	"button" : preload("res://addons/GMRT-Plugin/view/gmrt_btn.tscn").instance(),
	"main" : preload("res://addons/GMRT-Plugin/view/gmrt_mainview.tscn").instance(),
	"sep" : null,
	# Script Singleton
	"gmrtcore_path" : "res://addons/GMRT-Plugin/src/gmrtcore.gd",
	# Inspector plugin
	"inspectorplug" : preload("res://addons/GMRT-Plugin/src/editor/inspectorplugin.gd").new(),
};

# - - - - - - - - - - - - - - -
# Holds the animationn Editor Base Node
var animationEditor = null;

# - - - - - - - - - - - - - - -
# Holds reference to the editor animation time spin node
var animationTimePos = null;

# - - - - - - - - - - - - - - -
# Godot API Functions
# - - - - - - - - - - - - - - -
# Godot entre tree override
func _enter_tree():
	add_inspector_plugin(_view.inspectorplug);

	if(!_view.button.is_connected("pressed", self, "_on_button_press")):
		_view.button.connect("pressed", self, "_on_button_press");

	_view.sep = VSeparator.new();
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, _view.sep);
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, _view.button);

	_view.main.visible = false;
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, _view.main);

	if(animationEditor == null):
		animationEditor = __find_editor_class_name(
			__get_parent_by_level(get_editor_interface().get_editor_viewport(), 4),
			"AnimationPlayerEditor"
		);
	var animationTopBar = __find_editor_class_name(animationEditor, "HBoxContainer");
	animationTimePos = __find_editor_class_name(animationTopBar, "SpinBox");

	_view.main.ref_plug(self);


# - - - - - - - - - - - - - - -
# Godot on exit tree override
func _exit_tree():
	remove_inspector_plugin(_view.inspectorplug);

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

# - - - - - - - - - - - - - - -
# Godot APi override
# Returns true if this is a main screen editor plugin 
# (it goes in the workspace selector together with 2D, 3D, Script and AssetLib)
func has_main_screen(): return false;

# - - - - - - - - - - - - - - -
# Godot API override
# This function will be called when the editor is requested to become visible.
# It is used for plugins that edit a specific object type
func make_visible(visible):
	if(_view.main):
		_view.main.visible = visible;

# - - - - - - - - - - - - - - -
# Godot API Override
# Override this method in your plugin to provide the name of the plugin when displayed in the Godot editor.
# For main screen plugins, this appears at the top of the screen,
# to the right of the "2D", "3D", "Script", and "AssetLib" buttons.
func get_plugin_name(): return "GMRT";

# - - - - - - - - - - - - - - -
# Godot API override
# Override this method in your plugin to return a Texture in order to give it an icon.
# For main screen plugins, this appears at the top of the screen,
# to the right of the "2D", "3D", "Script", and "AssetLib" buttons.
# Ideally, the plugin icon should be white with a transparent background and 16x16 pixels in size.
func get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("ToolAddNode", "EditorIcons");

# - - - - - - - - - - - - - - -
# On GMRT button press callback
func _on_button_press():
	make_visible(!_view.main.visible);

# - - - - - - - - - - - - - - -
# Gets the editor root node
# Return {Node}: Editor root node
func __get_editor_root()-> Node:
	var rt = get_editor_interface().get_editor_viewport();
	while rt.get_parent()!= null:
		rt.get_parent();
	return rt;

# - - - - - - - - - - - - - - -
# Gets a node parent by level
# @root {Node}: Starting node
# @level {int}: Total parent levels
# Return {Node}: Last valid parent
func __get_parent_by_level(root: Node, level: int):
	var parent = root;
	for i in range(level):
		if(parent.get_parent() != null): parent = parent.get_parent();
	return parent;

# - - - - - - - - - - - - - - -
# From a defined not, finds recursive a target class name
# @root {Node}: Initial node
# @classname {String}: Target class name
# Return {Node/Null}: Found object or null
func __find_editor_class_name(root: Node, classname : String):
	if(root.get_child_count() != 0):
		for child in root.get_children():
			if(child.get_class() == classname):
				return child;
			elif(child.get_child_count() != 0):
				var res = __find_editor_class_name(child, classname);
				if(res != null):
					return res;
	return null;

# - - - - - - - - - - - - - - -
# Generates a random color
# Return {Color}: Random color
func __generate_random_color()-> Color:
	var rnd = RandomNumberGenerator.new();
	var col := [];
	for i in range(3):
		rnd.randomize();
		col.append(rnd.randf());
	return Color(col[0], col[1], col[2], 1.0);
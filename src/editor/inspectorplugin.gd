tool
extends EditorInspectorPlugin

# - - - - - - - - - - - - - - -
var _scaleAnimationInspector = null;

var _removeicon = null;

# - - - - - - - - - - - - - - -
# From Docs:
#   Returns true if this object can be handled by this plugin.
# Implement can_handle_override()-> bool if has a custom editor interface
func can_handle(object: Object):
	if(object is ScaleAnimation):
		if(_scaleAnimationInspector == null):
			_scaleAnimationInspector =\
				load("res://addons/GMRT-Plugin/src/nodes/inspector/scalable_animation_inspector.gd");
		return true;
	return false;


# - - - - - - - - - - - - - - -
# From Docs:
#   Called to allow adding property specific editors to the inspector.
#   Usually these inherit EditorProperty.
#   Returning true removes the built-in editor for this property,
#   otherwise allows to insert a custom editor before the built-in one.
# Implements parse_property_override(EditorInspectorPlugin,
#   type: int, path: String, hint: int, hint_text: String, usage: int)
# If adds to a property
func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int):
	if(path == "add_reference"):
		_scaleAnimationInspector.new(self, object);
		return true;
	
	var _split = path.split('_');
	if(_split.size() >= 3 && _split[2] == "remove"):
		if(_removeicon == null):
			_removeicon = load("res://addons/GMRT-Plugin/assets/icons/Remove.svg");

		var btn = ToolButton.new();
		btn.set_text("Remove");
		btn.connect("pressed", object, "set",[path, true]);
		btn.set_self_modulate(Color.red);
		btn.set_button_icon(_removeicon);
		add_custom_control(btn);
		return true;
		
	return false;
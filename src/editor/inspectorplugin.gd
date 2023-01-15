tool
extends EditorInspectorPlugin

# - - - - - - - - - - - - - - -
var _scaleAnimationInspector = null;

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
	if(["add_reference", "conditions"].find(path) != -1):
		if(path == "add_reference"):
			_scaleAnimationInspector.new(self, object);
		return true;
	return false;
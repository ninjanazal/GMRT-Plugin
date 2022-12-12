tool
extends EditorInspectorPlugin

# - - - - - - - - - - - - - - -
# From Docs:
#   Returns true if this object can be handled by this plugin.
# Implement can_handle_override()-> bool if has a custom editor interface
func can_handle(object: Object):
    if(object != null && object.has_method("can_handle_override")):
        return object.can_handle_override();
    return false;

# - - - - - - - - - - - - - - -
# From Docs:
#   Called to allow adding controls at the beginning of the list.
# Implements parse_begin_override(EditorInspectorPlugin)
# if adds to the begin of the custom inspector
func parse_begin(object: Object):
    if(object != null && object.has_method("parse_begin_override")):
        object.parse_begin_override(self);

# - - - - - - - - - - - - - - -
# From Docs:
#   Called to allow adding controls at the beginning of the category.
# Implements parse_category_override(EditorInspectorPlugin, category: String)
# If adds to a category
func parse_category(object: Object, category: String):
    if(object != null && object.has_method("parse_category_override")):
        object.parse_category_override(self, category);

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
    if(object != null && object.has_method("parse_property_override")):
        return object.parse_property_override(self, type, path, hint, hint_text, usage);
    return false;
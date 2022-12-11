tool
extends EditorInspectorPlugin

# - - - - - - - - - - - - - - -
func can_handle(object: Object):
    if(object != null && object.has_method("can_handle_override")):
        return object.can_handle_override();
    return false;

# - - - - - - - - - - - - - - -
func parse_begin(object: Object):
    if(object != null && object.has_method("parse_begin_override")):
        object.parse_begin_override(self);

# - - - - - - - - - - - - - - -
func parse_category(object: Object, category: String):
    if(object != null && object.has_method("parse_category_override")):
        object.parse_category_override(self, category);

func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int):
    if(object != null && object.has_method("parse_property_override")):
        return object.parse_property_override(self, type, path, hint, hint_text, usage);
    return false;
tool
extends Control
class_name ZControl, "res://addons/GMRT-Plugin/src/nodes/ZNodes/assets/zControl.png"

# - - - - - - - - - - - - - - -
# Z index value
var _z_index: int = 0;
# - - - - - - - - - - - - - - -
# Z index value is relative
var _z_is_relative: bool = true


# ==================== ====================
# GODOT VIRTUAL FUNCTIONS
# ==================== ====================
func _get_property_list():
	return [{
		"name": "Ordering",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_CATEGORY,
	}, {
		"name" : "z_index",
		"type" : TYPE_INT
	}, {
		"name" : "z_as_relative",
		"type" : TYPE_BOOL
	}
];


# - - - - - - - - - - - - - - -
func _get(property: String):
	var value_get = null;
	match property:
		"z_index": value_get = _z_index;
		"z_as_relative": value_get = _z_is_relative;
	return value_get;


# - - - - - - - - - - - - - - -
func _set(property: String, value):
	var value_set = true;
	match property:
		"z_index":
			_z_index = value;
			VisualServer.canvas_item_set_z_index(get_canvas_item(), _z_index);
		"z_as_relative":
			_z_is_relative = value;
			VisualServer.canvas_item_set_z_as_relative_to_parent(
					get_canvas_item(), _z_is_relative);
		_:
			value_set = false;
	return value_set;

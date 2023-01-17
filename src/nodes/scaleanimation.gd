tool
extends AnimationPlayer
class_name ScaleAnimation, "res://addons/GMRT-Plugin/assets/icons/ToolScale.png"

# - - - - - - - - - - - - - - -
# Existing coditions for trigger animation change
# Expected structure for each element
# {"name":String, "value": Value, "animation": String}
var conditions: Array = [];


# - - - - - - - - - - - - - - -
var _values : Dictionary = { };


# ==================== ====================
# GODOT API Overrides
# ==================== ====================

# - - - - - - - - - - - - - - -
# Godot API function override
func _enter_tree():
	if(get_animation_list().size() == 0 || !has_animation("DEFAULT")):
		if(Engine.is_editor_hint()):
			__create_default__();
		else:
			print_stack();
			push_error("ScaleAnimation object without default animation");
			return;

	assigned_animation = "DEFAULT";
	Gmrtcore.regist_scale_animation(self);


func _ready():
	if(!Engine.is_editor_hint()): clear_childs();


func _exit_tree():
	Gmrtcore.unregist_scale_animation(self);


# ==================== ====================
# PUBLIC FUNCTIONS
# ==================== ====================


# on View size change callback function
# This is used as a registed function on the GMRT singleton
func on_viewsize_change(ratio: float):
	seek(ratio, true);



# - - - - - - - - - - - - - - -
# Creates a new empty condition
# Used by the inspector
func create_condition():
	conditions.append( {
			"name" : "", "type" : Gmrtcore.CONDITIONTYPE.TYPE_BOOL,
			"value" : "0", "animation" : ""
		});
	property_list_changed_notify();


# - - - - - - - - - - - - - - -
# Removes the last condition on the array
func delete_condition():
	conditions.remove(conditions.size() - 1);
	property_list_changed_notify();


# - - - - - - - - - - - - - - -

func delete_condition_at(id: int):
	if(conditions.size() > id):
		conditions.remove(id);
		property_list_changed_notify();


# - - - - - - - - - - - - - - -
# Clears all the node childs
func clear_childs():
	for child in get_children():
		remove_child(child);
		child.queue_free();


# ==================== ====================
# PRIVATE FUNCTIONS
# ==================== ====================


# - - - - - - - - - - - - - - -
# Creates the default animation
func __create_default__():
	var tmp = Animation.new();
	tmp.set_length(20.0);
	tmp.set_step(0.001);

	if(add_animation("DEFAULT", tmp) != OK):
		push_error("ScaleAnimation failded to create default animation");

# - - - - - - - - - - - - - - -
# Setter for the reference view, value discarded
func __set_add_reference():
	if(Engine.is_editor_hint()):
		clear_childs();
		
		var tmp = ReferenceRect.new();
		tmp.set_name("EditorOnly-RefView");
		tmp.set_border_color(__generate_random_color());
		tmp.set_border_width(4);
		tmp.set_anchors_preset(Control.PRESET_WIDE);
		add_child(tmp);


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


# ==================== ====================
# GODOT VIRTUAL FUNCTIONS
# ==================== ====================


# - - - - - - - - - - - - - - -
func _get_property_list():
	var properties = [];
	#{ "value": Value, "type": Type, "animation": String}
	properties.append_array([
		{ "name" : "add_reference",	"type": TYPE_BOOL }
	]);

	if(!conditions.empty()):
		properties.append({
			"name" : "Conditions",
			"type" : TYPE_NIL,
			"usage" : PROPERTY_USAGE_CATEGORY
		});

	for i in conditions.size():
		properties.append_array([
			# @Group
			{
				"name" : str(i),
				"type" : TYPE_NIL,
				"usage" : PROPERTY_USAGE_GROUP,
				"hint_string" : "condition_%s_" % str(i)
			},
			{ "name" : "condition_%s_name" % str(i), "type" : TYPE_STRING },
			{
				"name" : "condition_%s_type" % str(i),
				"type" : TYPE_INT,
				"hint" : PROPERTY_HINT_ENUM,
				"hint_string" : ",".join(Gmrtcore.CONDITIONTYPE.keys())
			}]);

		var conditionType: Dictionary = {"name" : "condition_%s_value" % str(i), "type" : conditions[i].type + 1};
		if(conditionType.type == Gmrtcore.CONDITIONTYPE.TYPE_LAYOUT):
			conditionType.type = TYPE_INT;
			conditionType["hint"] = PROPERTY_HINT_ENUM;
			conditionType["hint_string"] = ",".join(Gmrtcore.LAYOUT_TYPE.keys());
		
		properties.append_array([
			conditionType,
			{ "name" : "condition_%s_animation" % str(i), "type" : TYPE_STRING },
			{ "name" : "condition_%s_remove" % str(i), "type" : TYPE_BOOL}
		]);
	return properties;


# - - - - - - - - - - - - - - -
func _set(property, value):
	var value_set = true;
	
	var _split = property.split("_");
	if(_split[0] == "condition"):
		if(_split[2] == "remove"):
			if(value):
				delete_condition_at(int(_split[1]));
				return true;
		
		if(conditions.size() - 1 < int(_split[1])):
			create_condition();
				
		conditions[int(_split[1])][_split[2]] = value;
		if(_split[2] == "type"):
			property_list_changed_notify();
		return true;
	
	match property:
		"add_reference": __set_add_reference();
		_:
			value_set = false;
	return value_set;


# - - - - - - - - - - - - - - -
func _get(property):
	var value = null;
	
	var _split = property.split("_");
	if(_split[0] == "condition"):
		if(_split[2] == "remove"):
			return false;
		
		value = conditions[int(_split[1])][_split[2]];
		return value;
	
	match property:
		"add_reference": value = null;
		_:
			value = null;
	return value;

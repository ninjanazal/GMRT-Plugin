tool
extends AnimationPlayer
class_name ScaleAnimation, "res://addons/GMRT-Plugin/assets/icons/ToolScale.png"

# - - - - - - - - - - - - - - -
# Exported toggle for adding a reference viewer
export (bool) var add_reference = false setget __set_add_reference;

# - - - - - - - - - - - - - - -
# Existing coditions for trigger animation change
# Expected structure for each element
# {"name":String, "value": Value, "animation": String}
export (Array, Dictionary) var conditions = [];

# on View size change callback function
# This is used as a registed function on the GMRT singleton
func on_viewsize_change(ratio: float):
	seek(ratio, true);

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

# - - - - - - - - - - - - - - -
# Creates a new empty condition
# Used by the inspector
func create_condition():
	conditions.append({	"name" : null, "value": null, "animation": null});
	property_list_changed_notify();


# - - - - - - - - - - - - - - -
func delete_condition(id: int):
	if(conditions.size() <= id): return;
	conditions.remove(id);

	property_list_changed_notify();

# - - - - - - - - - - - - - - -
# Clears all the node childs
func clear_childs():
	for child in get_children():
		remove_child(child);
		child.queue_free();

# - - - - - - - - - - - - - - -
# Creates the default animation
func __create_default__():
	var tmp = Animation.new();
	tmp.set_length(20.0);
	tmp.set_step(0.01);

	if(add_animation("DEFAULT", tmp) != OK):
		push_error("ScaleAnimation failded to create default animation");

# - - - - - - - - - - - - - - -
# Setter for the reference view, value discarded
func __set_add_reference(value: bool):
	if(Engine.is_editor_hint()):
		clear_childs();
		
		var tmp = ReferenceRect.new();
		tmp.set_name("EditorOnly-RefView");
		tmp.set_border_color(__generate_random_color());
		tmp.set_border_width(4);
		tmp.set_anchors_preset(Control.PRESET_WIDE);
		add_child(tmp);
		tmp.set_owner(get_tree().get_edited_scene_root());
		
		# Updates editor
		property_list_changed_notify();

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

# - - - - - - - - - - - - - - -
# @Inspector
# Called function from editor plugin to validate if exists a custom inspector inplementation
# Return {bool}: Should be handled by class
func can_handle_override()-> bool: return true;

# - - - - - - - - - - - - - - -
# Parse_Property override, add a custom view to the Script Variables
func parse_category_override(plug: EditorInspectorPlugin, category: String):
	if(category == "Script Variables"):
		ScaleAnimationInspector.new(plug, self);

# - - - - - - - - - - - - - - -
func parse_property_override(plug: EditorInspectorPlugin,
		type: int, path: String, hint: int, hint_text: String, usage: int):
	return (["add_reference", "conditions"].find(path) != -1);
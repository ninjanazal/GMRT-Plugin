tool
extends AnimationPlayer
class_name ScaleAnimation, "res://addons/GMRT-Plugin/assets/icons/ToolScale.png"

# on View size change callback function
# This is used as a registed function on the GMRT singleton
func on_viewsize_change(ratio: float):
	print("Seek to: %s" % ratio);
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
	GmrtCore.regist_scale_animation(self);

func _exit_tree():
	GmrtCore.unregist_scale_animation(self);
# - - - - - - - - - - - - - - -


# Creates the default animation
func __create_default__():
	var tmp = Animation.new();
	tmp.set_length(20.0);
	tmp.set_step(0.01);

	if(add_animation("DEFAULT", tmp) != OK):
		push_error("ScaleAnimation failded to create default animation");


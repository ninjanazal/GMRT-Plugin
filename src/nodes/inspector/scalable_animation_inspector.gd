tool
extends Control
class_name ScaleAnimationInspector

# - - - - - - - - - - - - - - -
var _packed_view = preload("res://addons/GMRT-Plugin/src/nodes/inspector/scale_animation_inspector.tscn");

var _comp := {
	"view" : null,
	"add_ref_btn" : null,
	"condition_btn" : null,
	"conditions" : null
};
var _insp_view = null;


# - - - - - - - - - - - - - - -
# Initialize the ScaleAnimation Inspector, connection and drawing
# @plug {EditorInspectorPlugin}: Reference for the source Inspector pluging
# @src {ScaleAnimation}: Refered ScaleAnimation object
func initialize(plug: EditorInspectorPlugin, src):
	_create(plug);
	_connect(src);
	return self;


# - - - - - - - - - - - - - - -
func _create(plug: EditorInspectorPlugin):
	_comp.view = _packed_view.instance();
	_comp.add_ref_btn = _comp.view.get_node("refresh_btn");
	_comp.condition_btn = _comp.view.get_node("HBoxContainer/conditions_display_btn");
	_comp.conditions = _comp.view.get_node("conditions");
	_comp.conditions.hide();

	plug.add_custom_control(_comp.view);

func _connect(src):
	_comp.add_ref_btn.connect("toggled", src, "__set_add_reference");

tool
extends Control
class_name ScaleAnimationInspector

# - - - - - - - - - - - - - - -
var _packed_view = preload("res://addons/GMRT-Plugin/src/nodes/inspector/scale_animation_inspector.tscn");


# - - - - - - - - - - - - - - -
var _icons = {
	"arrow_right": preload("res://addons/GMRT-Plugin/assets/icons/ArrowRight.svg"),
	"arrow_down" : preload("res://addons/GMRT-Plugin/assets/icons/ArrowDown.svg")
}

var _comp := {
	"view" : _packed_view.instance(),
	"add_ref_btn" : null,
	"condition_count" : null, 
	"condition_add" : null,
	"condition_remove" : null,
};

var _source = null;

# - - - - - - - - - - - - - - -
# Initialize the ScaleAnimation Inspector, connection and drawing
# @plug {EditorInspectorPlugin}: Reference for the source Inspector pluging
# @src {ScaleAnimation}: Refered ScaleAnimation object
func _init(plug, src):
	_source = src;
	_create(plug);
	_connect();
	update_property();

# - - - - - - - - - - - - - - -
func _create(plug):
	_comp.add_ref_btn = _comp.view.get_node("refresh_btn");
	_comp.condition_count = _comp.view.get_node("HBoxContainer/condition_count");
	_comp.condition_add = _comp.view.get_node("HBoxContainer/add_btn");
	_comp.condition_remove = _comp.view.get_node("HBoxContainer/remove_btn");
	plug.add_custom_control(_comp.view);


func _connect():
	_comp.add_ref_btn.connect("pressed", self, "_on_add_reference");
	_comp.condition_add.connect("pressed", _source, "create_condition");
	_comp.condition_remove.connect("pressed", _source, "delete_condition");


func _on_add_reference(): _source.set("add_reference", true);


# - - - - - - - - - - - - - - -
func update_property():
	_comp.condition_count.set_text(
		"( %s )" % _source.conditions.size()
	);

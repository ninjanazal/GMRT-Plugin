tool
extends Control
class_name ScaleAnimationInspector

# - - - - - - - - - - - - - - -
var _packed_view = preload("res://addons/GMRT-Plugin/src/nodes/inspector/scale_animation_inspector.tscn");

# - - - - - - - - - - - - - - -
var _condition_view = preload("res://addons/GMRT-Plugin/src/nodes/inspector/scale_animation_condition_view.tscn");

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
	"conditions" : null,
};

var _source = null;

# - - - - - - - - - - - - - - -
# Initialize the ScaleAnimation Inspector, connection and drawing
# @plug {EditorInspectorPlugin}: Reference for the source Inspector pluging
# @src {ScaleAnimation}: Refered ScaleAnimation object
func _init(plug: EditorInspectorPlugin, src):
	_source = src;
	_create(plug);
	_connect();
	_update_view();

# - - - - - - - - - - - - - - -
func _create(plug: EditorInspectorPlugin):
	_comp.add_ref_btn = _comp.view.get_node("refresh_btn");
	_comp.condition_count = _comp.view.get_node("HBoxContainer/condition_count");
	_comp.condition_add = _comp.view.get_node("HBoxContainer/add_btn");
	_comp.conditions = _comp.view.get_node("conditions");
	plug.add_custom_control(_comp.view);


func _connect():
	_comp.add_ref_btn.connect("toggled", _source, "__set_add_reference");
	_comp.condition_add.connect("pressed", _source, "create_condition");

# - - - - - - - - - - - - - - -
func _update_view():
	_comp.condition_count.set_text(
		"( %s )" % _source.conditions.size()
	);
	for i in _source.conditions.size():
		var cView = _condition_view.instance().initialize(_source, i);
		_comp.conditions.add_child(cView);

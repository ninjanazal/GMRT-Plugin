tool
extends Control

# - - - - - - - - - - - - - - -
# Reference to the View saleanimation object
var _source = null;

# - - - - - - - - - - - - - - -
# Holds the setted condition view id
var _condition_id = null;

# - - - - - - - - - - - - - - -
# Component references
var _comp :Dictionary = {
	"id" : null,
	"name_input" : null,
	"value_input" : null,
	"animation_name" : null,
	"delete_btn": null
};


# - - - - - - - - - - - - - - -
# Initializes the inspect condition view 
# @src {ScaleAnimation}: Source scale animation object
# @id {int}: Defined object id
func initialize(src, id: int):
	_source = src;
	_condition_id = id;

	_create();
	_update_view();
	_connections();
	
	return self;

# - - - - - - - - - - - - - - -
# Create references from the condition node tree
func _create():
	_comp.id = get_node("HBoxContainer/condition_id");
	_comp.name_input = get_node("HBoxContainer/VBoxContainer/HBoxContainer/name_input");
	_comp.value_input = get_node("HBoxContainer/VBoxContainer/HBoxContainer2/value_input");
	_comp.animation_name = get_node("HBoxContainer/VBoxContainer/HBoxContainer3/animation_name");
	_comp.delete_btn = get_node("HBoxContainer/delete_btn");

# - - - - - - - - - - - - - - -
# Updates the condition view with the current state
func _update_view():
	_comp.id.set_text(str(_condition_id));


# - - - - - - - - - - - - - - -
# Generate Connections for the current view
func _connections():
	_comp.delete_btn.connect("pressed", _source, "delete_condition", [_condition_id]);

tool
extends Control

# - - - - - - - - - - - - - - - -
# Class Status Entry
class StatusEntry:
	var _ref: Control = null;
	var _btn: Button = null;

	# Constructor
	# @baseRef {Control}: Target Status base object
	func _init(baseRef: Control):
		_ref = baseRef;
		__find_button_on__(_ref);

	# Defines the button press state
	# @val {bool}: Button press state
	func set_button_pressed(val: bool, disable_on_positive: bool = true):
		if(_btn != null):
			_btn.pressed = val;
			
			if(disable_on_positive): _btn.disabled = val;
			else: _btn.disabled = false;
			
			_btn.self_modulate =\
				Color("a2ffa1") if val else Color.white;

	# Connects the action button to a target callback
	# @target {Object}: Callable object
	# @funcName {String}: Call function namea
	func connect_pressed(target: Object, funcName: String):
		if(_btn != null && !_btn.is_connected("pressed", target, funcName)):
			_btn.connect("pressed", target, funcName);
	
	# Disconnects the action button to a target callback
	# @target {object}: Callable object
	# @funcName {String}: Call function name
	func disconnect_pressed(target: Object, funcName: String):
		if(_btn != null && _btn.is_connected("pressed", target, funcName)):
			_btn.disconnect("pressed", target, funcName);
		
	func __find_button_on__(root: Node):
		for child in root.get_children():
			if(child is Button):
				_btn = child;
				return;
			if(child.get_child_count() != 0):
				__find_button_on__(child);
# - - - - - - - - - - - - - - - -


export (NodePath) var base_viewport_cont = null;
export (NodePath) var strech_mode_cont = null;
export (NodePath) var strech_aspect_cont = null;
export (NodePath) var handheld_cont = null;
export (NodePath) var gpupixel_snap_cont = null;
export (NodePath) var vertexcolor_batching_cont = null;


var _elms : Dictionary = {
	"viewportSize" : null,
	"strechmode" : null,
	"strechaspect" : null,
	"handheld" : null,
	"gpupixelsnap" : null,
	"vertexcolorbatching" : null
}

# - - - - - - - - - - - - - - - -
# API override functions
func _enter_tree():
	var _nPaths = [base_viewport_cont, strech_mode_cont, strech_aspect_cont,
		handheld_cont, gpupixel_snap_cont, vertexcolor_batching_cont];
	for i in _nPaths.size():
		var tmp = get_node_or_null(_nPaths[i]);
		if(tmp != null):
			_elms[_elms.keys()[i]] = StatusEntry.new(tmp);

	_generate_connections();

func _exit_tree():
	_clear_connections();
	for i in _elms.size():
		_elms[_elms.keys()[i]] = null;
# - - - - - - - - - - - - - - - -

# - - - - - - - - - - - - - - - -
# Validations
func _eval_project_state():
	_eval_viewport_size();
	_eval_strech_mode();
	_eval_strech_aspect();
	_evel_handheld();
	_eval_gpupixelsnap();
	_eval_vertecolorbatching();

func _eval_viewport_size():
	var h = ProjectSettings.get_setting("display/window/size/height");
	var w = ProjectSettings.get_setting("display/window/size/width");

	_elms.viewportSize.set_button_pressed(h == w);

func _eval_strech_mode():
	_elms.strechmode.set_button_pressed(ProjectSettings.get_setting("display/window/stretch/mode") == "2d");

func _eval_strech_aspect():
	_elms.strechaspect.set_button_pressed(
		ProjectSettings.get_setting("display/window/stretch/aspect") == "expand");

func _evel_handheld():
	_elms.handheld.set_button_pressed(
		ProjectSettings.get_setting("display/window/handheld/orientation") == "sensor");

func _eval_gpupixelsnap():
	_elms.gpupixelsnap.set_button_pressed(
		ProjectSettings.get_setting("rendering/2d/snapping/use_gpu_pixel_snap"), false);

func _eval_vertecolorbatching():
	_elms.vertexcolorbatching.set_button_pressed(
		ProjectSettings.get_setting("rendering/batching/parameters/colored_vertex_format_threshold") == 0
	);
# - - - - - - - - - - - - - - - -

# - - - - - - - - - - - - - - - -
# Connections
func _generate_connections():
	#warning-ignore:retun_value_discarded
	ProjectSettings.connect("project_settings_changed", self, "_on_project_settings_changed");
	
	if(_elms.viewportSize != null): _elms.viewportSize.connect_pressed(self, "_on_viewport_press");
	if(_elms.strechmode != null): _elms.strechmode.connect_pressed(self, "_on_strech_mode_press");
	if(_elms.strechaspect != null): _elms.strechaspect.connect_pressed(self, "_on_strech_aspect_press");
	if(_elms.handheld != null): _elms.handheld.connect_pressed(self, "_on_handheld_press");
	if(_elms.gpupixelsnap != null): _elms.gpupixelsnap.connect_pressed(self, "_on_gpupixelsnap_press");
	if(_elms.vertexcolorbatching != null): _elms.vertexcolorbatching.connect_pressed(self, "_on_vertexcolorbatching_press");
	_eval_project_state();


# Clears the Status tab connections
func _clear_connections():
	if(ProjectSettings.is_connected("project_settings_changed", self, "_on_project_settings_changed")):
		ProjectSettings.disconnect("project_settings_changed", self, "_on_project_settings_changed");
	
	if(_elms.viewportSize != null): _elms.viewportSize.disconnect_pressed(self, "_on_viewport_press");
	if(_elms.strechmode != null): _elms.strechmode.disconnect_pressed(self, "_on_strech_mode_press");
	if(_elms.strechaspect != null): _elms.strechaspect.disconnect_pressed(self, "_on_strech_aspect_press");
	if(_elms.handheld != null): _elms.handheld.disconnect_pressed(self, "_on_handheld_press");
	if(_elms.gpupixelsnap != null): _elms.gpupixelsnap.disconnect_pressed(self, "_on_gpupixelsnap_press");
	if(_elms.vertexcolorbatching != null): _elms.vertexcolorbatching.disconnect_pressed(self, "_on_vertexcolorbatching_press");

# - - - - - - - - - - - - - - - -

# On project settings change callback function
func _on_project_settings_changed(): _eval_project_state();

# On viewport action button press callback
func _on_viewport_press():
	var gmrtSingle = null;
	if(Engine.has_singleton("Gmrtcore")):
		gmrtSingle = Engine.get_singleton("Gmrtcore");
		ProjectSettings.set_setting("display/window/size/width", gmrtSingle.BASE_SIZE.x);
		ProjectSettings.set_setting("display/window/size/height", gmrtSingle.BASE_SIZE.y);

# On Strech mode action button press callback
func _on_strech_mode_press():
	ProjectSettings.set_setting("display/window/stretch/mode", "2d");

# On Strech aspect action button press callback
func _on_strech_aspect_press():
	ProjectSettings.set_setting("display/window/stretch/aspect", "expand");

# on Handheld action button press callback
func _on_handheld_press():
	ProjectSettings.set_setting("display/window/handheld/orientation", "sensor");

# On Gpu Pixel snap button press callback
func _on_gpupixelsnap_press():
	ProjectSettings.set_setting(
		"rendering/2d/snapping/use_gpu_pixel_snap",
		!ProjectSettings.get_setting("rendering/2d/snapping/use_gpu_pixel_snap"));

# On Vertex Color batching button press callback
func _on_vertexcolorbatching_press():
	ProjectSettings.set_setting(
		"rendering/batching/parameters/colored_vertex_format_threshold",
		0
	);

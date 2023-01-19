class_name StatusEntry

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
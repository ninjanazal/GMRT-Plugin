tool
extends Control;

# - - - - - - - - - - - - - - -
# Exported node path to the emulate tab
export (NodePath) var emulate_tab_path = null;

# - - - - - - - - - - - - - - -
# Parent plugin reference
var plugRef = null;

# - - - - - - - - - - - - - - -
# References the base plugin 
func ref_plug(plug):
	plugRef = plug;
	var emulTab = get_node_or_null(emulate_tab_path);
	if(emulTab != null):
		emulTab.ref_plug(plugRef);

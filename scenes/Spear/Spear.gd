extends RigidBody2D

var thrown
var throw_to

func _process(delta):
	if(Input.is_action_just_pressed("right_click")):
		var joint = get_parent().get_child(0)
		joint.node_b = ""
		throw_to = get_global_mouse_position()-get_global_position()
		thrown = true
	
func _integrate_forces(state):
	if(thrown):
		apply_central_impulse(throw_to.normalized() * 80)
	else:
		look_at(get_global_mouse_position())
	
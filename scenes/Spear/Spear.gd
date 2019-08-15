extends RigidBody2D

var thrown = false
var throw_to = Vector2()
var velocity = Vector2()
var speed = 1000


func _process(delta):
#	if(!thrown):
#		look_at(get_global_mouse_position())
	if(Input.is_action_just_pressed("right_click") && !thrown):
		var joint = get_parent().get_child(0)
		joint.node_b = ""
		throw_to = get_global_mouse_position()-get_global_position()
		look_at(get_global_mouse_position())
		apply_central_impulse(throw_to.normalized()*speed)
		thrown = true

func _on_Spear_body_entered(body):
	if(thrown):
		var save_pos = get_global_position()
		linear_velocity = Vector2(0,0)
		call_deferred("set_mode", (RigidBody2D.MODE_KINEMATIC))
		#var copy = self
		get_parent().call_deferred("remove_child",self)
		body.call_deferred("add_child",self)
		position = save_pos - get_global_position()

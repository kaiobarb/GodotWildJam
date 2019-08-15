extends RigidBody2D

var thrown = false
var throw_to = Vector2()
var velocity = Vector2()
var speed = 700

func _ready():
	set_mode(RigidBody2D.MODE_KINEMATIC)
	add_collision_exception_with(get_parent())

func _process(delta):
	if(!thrown):
		look_at(get_global_mouse_position())
	if(Input.is_action_just_pressed("right_click") && !thrown):
		var joint = get_parent().get_child(0)
		var yoint = $"../PinJoint2D"
		yoint.node_b = ""
		throw_to = get_global_mouse_position()-get_global_position()
		set_mode(RigidBody2D.MODE_RIGID)
		apply_central_impulse(throw_to.normalized()*speed)
		thrown = true

func _on_Spear_body_entered(body):
	if(thrown):
		call_deferred("set_mode", (RigidBody2D.MODE_STATIC))
		get_parent().call_deferred("remove_child",self)
		body.call_deferred("add_child",self)
		position = -get_global_position() + get_parent().get_global_position()
		look_at(get_parent().get_global_position())

extends RigidBody2D

var thrown = false
var throw_to = Vector2()
var velocity = Vector2()
var speed = 700


onready var chain_scn = preload("res://scenes/Chain/Chain.tscn")

func _ready():
	set_mode(RigidBody2D.MODE_KINEMATIC)
	add_collision_exception_with(get_parent())
	add_collision_exception_with(self)

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
		if(body.name.find("Planet") >= 0):
			# Stick spear into planet and change it's parent to be the planet
			call_deferred("set_mode", (RigidBody2D.MODE_STATIC))
			get_parent().call_deferred("remove_child",self)
			body.call_deferred("add_child",self)
			position = -get_global_position() + get_parent().get_global_position()
			look_at(get_parent().get_global_position())
		# Update chain 
		if(globals.end_points.size() < 2):
			globals.end_points.append(body)
			if(globals.end_points.size() == 2):
				create_chain()
			print(globals.end_points.size())
			
func create_chain():
	var ep = globals.end_points
	var chain = chain_scn.instance()
	var distance_btwn = ep[0].get_global_position() - ep[1].get_global_position()
	var chain_length = (distance_btwn).length()
	chain.length = chain_length
	# "Begin" area (see Chain scene)
	var begin = chain.get_child(0)
	# "End" area
	var end = chain.get_child(1)
	# Get planet joints
	var joint0 = ep[0].get_child(1)
	var joint1 = ep[1].get_child(1)
	# connect
	joint0.set_node_b(begin.name)
	joint1.set_node_b(end.name)
	chain.position = -distance_btwn
	ep[0].call_deferred("add_child",chain)
	globals.end_points = []
	
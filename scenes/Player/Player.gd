extends RigidBody2D

#onready var planet_position = get_parent().find_node("Planet").get_global_position()
var planet_position = Vector2(0,0)
var spear_scn = preload("res://scenes/Spear/Spear.tscn")
var spear
var MAX_SPEED = 570.0
var lateral_speed = 124.0
var jump_strength = 5000
var damp
var jumping = false

func _ready():
	damp = linear_damp

	
func _integrate_forces(state):
	look_at(planet_position)
	if(Input.is_action_just_pressed("ui_jump")):
		apply_central_impulse(-vector_to_planet().normalized()*jump_strength)
		linear_damp = 0
	elif(Input.is_action_just_released("ui_jump")):
		linear_damp = 0
#		apply_central_impulse(vector_to_planet().normalized()*100)
#		apply_central_impulse(get_perpendicular(vector_to_planet()).normalized() * 180)
	elif(Input.is_action_pressed("ui_right") && state.linear_velocity.length() < MAX_SPEED):
		var v2p = vector_to_planet()
		apply_central_impulse(get_perpendicular(v2p).normalized() * lateral_speed)
		linear_damp = 0
	elif(Input.is_action_pressed("ui_left") && state.linear_velocity.length() < MAX_SPEED):
		var v2p = vector_to_planet()
		apply_central_impulse(-get_perpendicular(v2p).normalized() * lateral_speed)
		linear_damp = 0
	else:
		linear_damp = damp
		#apply_central_impulse(vector_to_planet().normalized()*1000)
	
func _process(delta):
	vector_to_planet()
	if(Input.is_action_just_pressed("right_click")):
		$Timer.start()

func vector_to_planet():
	var player_position = get_global_position()
	return get_vector_from_to(player_position, planet_position)

func get_vector_from_to(var A, var B):
	# TODO: deal with absolute
	globals.debug_vec = (B-A)
	return B-A
	
func get_perpendicular(var A):
	var result = A.rotated(deg2rad(-90))
	return result

func _on_Player_body_entered(body):
	linear_damp = 0

func _on_Timer_timeout():
	$Timer.stop()
	spear = spear_scn.instance()
	spear.name = "Spear_" + String(spear.get_instance_id())
	spear.position = Vector2(0,0)
	$PinJoint2D.set_node_b(spear.name)
	add_child(spear)
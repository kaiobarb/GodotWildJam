extends RigidBody2D

onready var planet_position = get_parent().get_parent().find_node("Planet").get_global_position()


func _integrate_forces(state):
	look_at(planet_position)
	rotate(-PI/2)
	if(Input.is_action_just_pressed("ui_jump")):
		apply_central_impulse(-vector_to_planet().normalized()*300)
	elif(Input.is_action_pressed("ui_right")):
		var v2p = vector_to_planet()
		#globals.debug_array.remove(1)
		#globals.debug_array.insert(1,result)
		#globals.debug_array.insert(1, get_perpendicular(v2p).normalized() * 8)
		apply_central_impulse(get_perpendicular(v2p).normalized() * 8)
	elif(Input.is_action_pressed("ui_left")):
		var v2p = vector_to_planet()
		#globals.debug_array.remove(1)
		#globals.debug_array.insert(1,result)
		#globals.debug_array.insert(1, get_perpendicular(v2p).normalized() * 8)
		apply_central_impulse(-get_perpendicular(v2p).normalized() * 8)
	
func _process(delta):
	vector_to_planet()

func vector_to_planet():
	var player_position = get_global_position()
#	print("planet pos: "+String(planet_position))
#	print("player pos: "+String(player_position))
	return get_vector_from_to(player_position, planet_position)

func get_vector_from_to(var A, var B):
	# TODO: deal with absolute
	globals.debug_vec = (B-A)
	return B-A
	
func get_perpendicular(var A):
	var result = A.rotated(deg2rad(-90))
	return result
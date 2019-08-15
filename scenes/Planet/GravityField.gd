extends Area2D

func _ready():
	pass

func _on_GravityField_body_entered(body):
	if(body.name == "Player"):
		body.planet_position = get_parent().get_global_position()

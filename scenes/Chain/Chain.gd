extends Node2D

onready var spring_joint = $DampedSpringJoint2D
onready var chain_sprite = $DampedSpringJoint2D/Sprite
var length = 50

func _process(delta):
	spring_joint.length = length
	chain_sprite.region_rect.size.x = length
	chain_sprite.texture.width = length
	$End.position.y = length
func _on_Timer_timeout():
	$Timer.start()

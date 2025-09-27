extends Area2D

var target_position = Vector2(139.0*8, -4.0) # put your coords here

func _on_body_entered(body):
	if body.name == "Player":
		body.global_position = target_position
		print(body)

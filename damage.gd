extends Area2D

# Damage pickup that deals 50 damage to the player on contact
var damage_applied: bool = false

func _ready() -> void:
	# Connect the body_entered signal to detect player collision
	body_entered.connect(_on_player_entered)
	print("Damage pickup ready!")

func _on_player_entered(body: Node2D) -> void:
	if damage_applied:
		return
		
	if body.name == "Player" and body.has_method('take_damage'):
		damage_applied = true
		
		# Deal 50 damage to the player
		body.take_damage(50)
		print("Damage pickup dealt 50 damage to player!")
		
		# Remove the damage pickup after use
		queue_free()
		print("Damage pickup consumed!")

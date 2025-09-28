extends Area2D

# Reference to the fridge boss
var fridge_boss: CharacterBody2D

func _ready() -> void:
	# Find the fridge boss when teleporter is ready
	fridge_boss = _find_fridge_boss()

func _find_fridge_boss() -> CharacterBody2D:
	# Search for fridge boss in the scene
	for node in get_tree().current_scene.get_children():
		if node is CharacterBody2D and node.has_method('take_damage') and not node.has_method('get_health_percentage'):
			# Check if it has boss-level health (200 HP)
			if node.has_method('get') and node.get('health') != null and node.get('health') >= 150:
				return node
		# Check nested nodes
		var found = _find_fridge_recursive(node)
		if found:
			return found
	return null

func _find_fridge_recursive(node: Node) -> CharacterBody2D:
	for child in node.get_children():
		if child is CharacterBody2D and child.has_method('take_damage') and not child.has_method('get_health_percentage'):
			if child.has_method('get') and child.get('health') != null and child.get('health') >= 150:
				return child
		var found = _find_fridge_recursive(child)
		if found:
			return found
	return null

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Check if fridge boss is dead before allowing teleportation
		if _is_fridge_dead():
			body.global_position = $tp.global_position
			print("Player teleported! Fridge boss defeated.")
		else:
			print("Teleporter locked! Defeat the Fridge boss first.")

func _is_fridge_dead() -> bool:
	# If we never found a fridge, consider it "dead" (allows teleport)
	if not fridge_boss:
		return true
	
	# If fridge reference is no longer valid, it's dead
	if not is_instance_valid(fridge_boss):
		return true
	
	# If fridge health is 0 or below, it's dead
	if fridge_boss.has_method('get') and fridge_boss.get('health') != null:
		return fridge_boss.get('health') <= 0
	
	# Default to locked if we can't determine health
	return false

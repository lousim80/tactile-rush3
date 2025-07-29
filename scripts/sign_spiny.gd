extends Area2D

var speed := 0

func _on_body_entered(body):
	if body.name == "Player":
		await spin_player(body)

func spin_player(player):
	# Start a tween to spin the player 360 degrees in 0.5 seconds
	var tween = player.create_tween()
	tween.tween_property(player, "rotation_degrees", player.rotation_degrees + 360, 0.5)

	# Temporarily disable gravity and stop vertical movement
	player.gravity = 0
	player.velocity.y = 0

	# Save current speed, stop the player, and wait for the spin
	speed = player.speed
	player.speed = 0
	await tween.finished

	# Apply upward boost
	player.speed = speed
	player.velocity.y = -300
	player.rotation_degrees = 0
	await get_tree().create_timer(0.1).timeout

	# Restore gravity

	player.gravity = 20
	speed = 0


	# Optionally pause before allowing another interaction (cooldown)
	await get_tree().create_timer(2).timeout

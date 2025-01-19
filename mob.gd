extends RigidBody2D

func _ready() -> void:
	# Get an array of animation names from the sprite frames
	# Returns: Array[String] = ["walk", "swim", "fly"]
	var mob_types: Array[String] = $AnimatedSprite2D.sprite_frames.get_animation_names()
	
	# Select and play a random animation:
	# 1. randi() generates a random integer
	# 2. % mob_types.size() ensures our random number fits within our array size (0-2)
	# 3. mob_types[index] selects one of: "walk", "swim", or "fly"
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	
# Called when the mob exits the screen area
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Safely remove this mob instance from the game
	queue_free()

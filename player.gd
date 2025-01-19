extends Area2D

signal hit

@export var speed: int = 400 # How fast the player will move (pixels/sec).
var screen_size: Vector2 # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity: Vector2 = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0: # If there's any horizontal movement.
		$AnimatedSprite2D.animation = "walk" # Play the walking animation.
		$AnimatedSprite2D.flip_v = false # Don't flip the sprite vertically.
		$AnimatedSprite2D.flip_h = velocity.x < 0 # Flip horizontally if moving left.
	elif velocity.y != 0: # If there's vertical (but no horizontal) movement
		$AnimatedSprite2D.animation = "up" # Play the "up" animation
		$AnimatedSprite2D.flip_v = velocity.y > 0 # Flip vertically if moving down

func start(pos: Vector2) -> void:
	# Set the player's postion to wherever we specify.
	position = pos
	
	# make the player visable again.
	show()
	
	# Re-enable collisions by turing the collision shape back on.
	$CollisionShape2D.disabled = false

func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

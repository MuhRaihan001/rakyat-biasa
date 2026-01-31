class_name Player extends CharacterBody2D

@export var speed = 200.0
@onready var player_sprite: AnimatedSprite2D = $player_sprite

var is_can_move = true
var is_have_money = false

func _physics_process(_delta):
	if is_can_move:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
		velocity = direction * speed
		move_and_slide()

	# ANIMATION LOGIC
		if direction != Vector2.ZERO:
		# If moving more horizontally than vertically
			if abs(direction.x) > abs(direction.y):
				if direction.x > 0:
					player_sprite.play("move_left")
				else:
					player_sprite.play("move_right")
		# If moving more vertically than horizontally
			else:
				if direction.y > 0:
					player_sprite.play("move_down")
				else:
					player_sprite.play("move_up")
		else:
			player_sprite.stop() # Stops animation when you aren't touching keys
	else:
		return

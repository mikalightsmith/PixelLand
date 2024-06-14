extends CharacterBody2D


@export var speed = 400.0
@export var jump_force = -400.0

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 1000:
			velocity.y = 1000

	if Input.is_action_just_pressed("jump"): # and is_on_floor():
		velocity.y = jump_force

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if direction != 0:
		sprite.flip_h = (direction == -1)

	move_and_slide()

	update_animations(direction)
	
	print(velocity)
	
	
func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			ap.play("idle")
		else:
			ap.play("run")
	else:
		if velocity.y < 0:
			ap.play("jump")
		elif velocity.y > 0:
			ap.play("fall")

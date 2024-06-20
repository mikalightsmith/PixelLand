extends CharacterBody2D


@export var speed = 400.0
@export var jump_force = -400.0

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_crouching = false

func _process(delta):
	print(is_crouching)

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
		set_direction(direction)
	
	if Input.is_action_just_pressed("crouch"):
		toggle_crouch()
		
	move_and_slide()

	update_animations(direction)
	
	print(velocity)
	
	
func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			if is_crouching:
				ap.play("crouch")
			else:
				ap.play("idle")
		else:
			if is_crouching:
				ap.play("slide")
			else:
				ap.play("run")
	else:
		if velocity.y < 0:
			ap.play("jump")
		elif velocity.y > 0:
			ap.play("fall")

func set_direction(direction):
	sprite.flip_h = (direction == -1)
	sprite.position.x = direction * 7

func toggle_crouch():
	if is_crouching:
		is_crouching = false
	else:
		is_crouching = true

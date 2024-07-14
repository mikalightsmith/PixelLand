extends CharacterBody2D


@export var speed = 150.0
@export var jump_force = -300.0

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D
@onready var crouch_raycast_1 = $crouch_raycast_1
@onready var crouch_raycast_2 = $crouch_raycast_2
@onready var attack_timer = $AttackTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_crouching = false
var stuck_under_object = false
var is_attacking = false
 
var standing_cshape = preload("res://resources/warrior_standing_cshape.tres")
var crouching_cshape = preload("res://resources/warrior_crouching_cshape.tres")

func _process(delta):
	pass
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 1000:
			velocity.y = 1000

	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		attack_timer.start()
		
	if is_attacking && attack_timer.is_stopped():
		is_attacking = false
	
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
		crouch()
		stuck_under_object = false
	if Input.is_action_just_released("crouch"):
		if above_head_is_empty():
			stand()
		else:
			stuck_under_object = true
			
	if stuck_under_object && above_head_is_empty():
		stand()
		stuck_under_object = false
		
	move_and_slide()

	update_animations(direction)
	
func above_head_is_empty() -> bool:
	return not crouch_raycast_1.is_colliding() and not crouch_raycast_2.is_colliding()
	
func update_animations(direction):
	if is_attacking:
		ap.play("attack")
	elif is_on_floor():
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
		if is_crouching:
			ap.play("crouch")
			
		else:
			if velocity.y < 0:
				ap.play("jump")
			elif velocity.y > 0:
				ap.play("fall")

func set_direction(direction):
	sprite.flip_h = direction < 0
	sprite.position.x = -7 if direction < 0 else 7

func crouch():
	if is_crouching:
		return
	is_crouching = true
	cshape.shape = crouching_cshape
	cshape.position.y = -8

func stand():
	if not is_crouching:
		return
	is_crouching = false
	cshape.shape = standing_cshape
	cshape.position.y = -16

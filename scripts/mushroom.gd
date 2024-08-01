extends CharacterBody2D


@export var speed = 150.0
@export var jump_force = -300.0

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D
@onready var down_raycast_1 = $down_raycast_1
@onready var down_raycast_2 = $down_raycast_2
@onready var right_raycast_1 = $right_raycast_1
@onready var right_raycast_2 = $right_raycast_2
@onready var left_raycast_1 = $left_raycast_1
@onready var left_raycast_2 = $left_raycast_2
@onready var attack_timer = $AttackTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 1
var is_attacking = false

func _process(delta):
	pass
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 1000:
			velocity.y = 1000

	if direction == 1 && (!down_raycast_2.is_colliding() || right_raycast_1.is_colliding() || right_raycast_2.is_colliding()):
		direction = -1
		sprite.flip_h = false
		
	if direction == -1 && (!down_raycast_1.is_colliding() || left_raycast_1.is_colliding() || left_raycast_2.is_colliding()):
		direction = 1
		sprite.flip_h = true


	velocity.x = speed * direction * 0.5	

	move_and_slide()

	update_animations()
	
func update_animations():
	if is_attacking:
		ap.play("attack")
	elif is_on_floor():
		if velocity.x == 0:
			ap.play("idle")
		else:
			ap.play("run")
			

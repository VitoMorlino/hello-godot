extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -400.0

var is_dying = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim_player = get_node("AnimationPlayer")
@onready var anim_sprite2d = get_node("AnimatedSprite2D")

signal has_died_signal

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# stop doing movement stuff if we're dying
	if is_dying:
		move_and_slide() # keep falling, though
		return

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim_player.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		anim_sprite2d.set_flip_h(direction < 0) # flip sprite if we're facing left
		if velocity.y == 0:
			anim_player.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim_player.play("idle")
		
	if velocity.y > 0:
		anim_player.play("fall")

	move_and_slide()


func die(_cause):
	is_dying = true
	has_died_signal.emit()
	anim_player.play("death")
	await anim_player.animation_finished
	Game.reset_game()
	queue_free()
	get_tree().change_scene_to_file("res://mainmenu.tscn")

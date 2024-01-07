extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var MOVEMENT_SPEED = 150
var wants_to_chase = false
var is_defeated = false

@onready var anim_sprite2d = get_node("AnimatedSprite2D")
@onready var player = get_node("../../player/player_CharacterBody2D")

func _ready():
	player.has_died_signal.connect(_on_player_has_died_signal)

func _physics_process(delta):
	# stop doing movement stuff if we're dying
	if is_defeated:
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if wants_to_chase:
		var direction = (player.position - self.position).normalized()
		anim_sprite2d.set_flip_h(direction.x > 0)
		velocity.x = direction.x * MOVEMENT_SPEED
	else:
		velocity.x = 0
		
	if anim_sprite2d.animation != "death":
		if velocity.x:
			anim_sprite2d.play("jump")
		else:
			anim_sprite2d.play("idle")
	
	move_and_slide()

func _on_detection_area_body_entered(body):
	if body == player:
		wants_to_chase = true


func _on_leash_area_body_exited(body):
	if body == player:
		wants_to_chase = false


func _on_cause_damage_area_body_entered(body):
	# don't do damage if we're already dead
	if is_defeated:
		return
		
	if body == player:
		player.die(self)

func _on_player_has_died_signal():
	wants_to_chase = false

func _on_take_damage_area_body_entered(body):
	# don't take damage again if we're already dead
	if is_defeated:
		return
		
	if body == player:
		die(self)

func die(_cause):
	is_defeated = true
	add_collision_exception_with(player)
	Game.number_of_enemy_kills += 1
	Utilities.save_game()
	anim_sprite2d.play("death")
	await anim_sprite2d.animation_finished
	self.queue_free()

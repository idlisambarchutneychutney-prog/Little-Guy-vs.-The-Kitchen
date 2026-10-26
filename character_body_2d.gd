extends CharacterBody2D

@export var speed: float = 250.0
@export var max_health: int = 4
@export var attack_range: float = 320.0

@onready var sprite: Sprite2D = $Sprite2D

var normal_texture: Texture2D
var attacking_texture: Texture2D = preload("res://little guy with weapon.png")

var current_health: int = 4
var attack_timer: float = 0.0


func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING
	normal_texture = sprite.texture
	current_health = max_health
	if not is_in_group("player"):
		add_to_group("player")


func _physics_process(delta: float) -> void:
	# Handle attack image revert timer safely
	if attack_timer > 0.0:
		attack_timer -= delta
		if attack_timer <= 0.0 and is_instance_valid(sprite):
			sprite.texture = normal_texture

	# WASD Movement
	var input_dir := Vector2.ZERO
	if Input.is_key_pressed(KEY_W): input_dir.y -= 1
	if Input.is_key_pressed(KEY_S): input_dir.y += 1
	if Input.is_key_pressed(KEY_A): input_dir.x -= 1
	if Input.is_key_pressed(KEY_D): input_dir.x += 1

	velocity = input_dir.normalized() * speed
	move_and_slide()

	# R Key Attack
	if Input.is_key_pressed(KEY_R) and attack_timer <= 0.0:
		attack()


func attack() -> void:
	attack_timer = 0.3  # Keeps attack image on for 0.3 seconds
	sprite.texture = attacking_texture

	var monster = get_tree().get_first_node_in_group("monster") if get_tree() else null
	if not monster and get_parent():
		monster = get_parent().get_node_or_null("monster1")

	if monster:
		var dist = global_position.distance_to(monster.global_position)
		if dist <= attack_range:
			if monster.has_method("take_damage"):
				monster.take_damage(1)


func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		get_tree().change_scene_to_file("res://win.tscn")

extends CharacterBody2D

@export var speed: float = 280.0
@export var max_health: int = 4
@export var attack_range: float = 320.0

@onready var sprite: Sprite2D = $Sprite2D

var normal_texture: Texture2D
var knife_texture: Texture2D = preload("res://marshmallow with weapon.png")

var current_health: int = 4
var attack_timer: float = 0.0


func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING
	normal_texture = sprite.texture
	current_health = max_health
	if not is_in_group("monster"):
		add_to_group("monster")


func _physics_process(delta: float) -> void:
	# Handle attack image revert timer safely
	if attack_timer > 0.0:
		attack_timer -= delta
		if attack_timer <= 0.0 and is_instance_valid(sprite):
			sprite.texture = normal_texture

	# Arrow Keys Movement
	var input_dir := Vector2.ZERO
	if Input.is_key_pressed(KEY_UP): input_dir.y -= 1
	if Input.is_key_pressed(KEY_DOWN): input_dir.y += 1
	if Input.is_key_pressed(KEY_LEFT): input_dir.x -= 1
	if Input.is_key_pressed(KEY_RIGHT): input_dir.x += 1

	velocity = input_dir.normalized() * speed
	move_and_slide()

	# L Key Attack
	if Input.is_key_pressed(KEY_L) and attack_timer <= 0.0:
		attack()


func attack() -> void:
	attack_timer = 0.3  # Keeps knife image on for 0.3 seconds
	sprite.texture = knife_texture

	var player = get_tree().get_first_node_in_group("player") if get_tree() else null
	if not player and get_parent():
		player = get_parent().get_node_or_null("little guy")

	if player:
		var dist = global_position.distance_to(player.global_position)
		if dist <= attack_range:
			if player.has_method("take_damage"):
				player.take_damage(1)


func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		get_tree().change_scene_to_file("res://win.tscn")

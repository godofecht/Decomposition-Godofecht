extends KinematicBody2D

export var ACCELERATION = 2000
export var MAX_SPEED = 200
export var FRICTION = 800
export var BULLET_SPEED = 400

onready var Bullet_Scene = preload("res://Bullet/Bullet.tscn")

enum {
	RUNNING,
	STANDING
}

var state = RUNNING
var velocity = Vector2.ZERO
var direction_vector = Vector2.LEFT #Store direction for non movement animations

func _physics_process(delta: float) -> void:
	match(state):
		RUNNING:
			move_state(delta)
		STANDING:
			standing_state(delta)

func standing_state(delta: float):
	pass

func move_state(delta: float):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("KEY_RIGHT") - Input.get_action_strength("KEY_LEFT")
	input_vector.y = Input.get_action_strength("KEY_DOWN") - Input.get_action_strength("KEY_UP")
	input_vector = input_vector.normalized()
	var mouse_vec = get_global_mouse_position()
	var a = Vector2(-mouse_vec.y, mouse_vec.x).angle()
	var r_radians = get_global_mouse_position().angle_to(global_position)

	rotation_degrees = rad2deg(get_angle_to(get_global_mouse_position()) + rotation) + 90
	
	if input_vector != Vector2.ZERO:
		direction_vector = input_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	if Input.is_action_just_pressed("PRIMARY"):
		var bullet = Bullet_Scene.instance()
		bullet.global_position = global_position + Vector2(-10, 0).rotated(deg2rad(rotation_degrees + 90))
		bullet.apply_impulse(Vector2(0,0).rotated(deg2rad(rotation_degrees + 90)), Vector2(BULLET_SPEED, 0).rotated(deg2rad(rotation_degrees - 90)))
		get_parent().add_child(bullet)
	move()
	
func move():
	velocity = move_and_slide(velocity)

extends KinematicBody2D

export var ACCELERATION = 2000
export var MAX_SPEED = 200
export var FRICTION = 800
export var BULLET_SPEED = 400

onready var AnimationT = $AnimationTree
onready var AnimationState = $AnimationTree.get("parameters/playback")

onready var Bullet_Scene = preload("res://Bullet/Bullet.tscn")
onready var AbsorbCollision = $AbsorbArea/AbsorbCollision
onready var SuctionEmitter1 = $AbsorbArea/SuctionEmitter1
onready var SuctionEmitter2 = $AbsorbArea/SuctionEmitter2
onready var SuctionEmitter3 = $AbsorbArea/SuctionEmitter3

#SFX
onready var ShootingSFX = $ShootingSFX
onready var OnSuctionSFX = $OnSuctionSFX
onready var OnSuctionStartSFX = $SuctionPowerUpSFX
onready var OnSuctionFinishSFX = $SuctionPowerDownSFX

export(int) var ammo = 3


signal AmmoChange
func onAmmoSet():
	print(ammo)
	emit_signal("AmmoChange", ammo)



enum {
	RUNNING,
	SUCTION
}

var state = RUNNING
var velocity = Vector2.ZERO
var direction_vector = Vector2.LEFT #Store direction for non movement animations

func _ready() -> void:
	AnimationT.active = true

func _physics_process(delta: float) -> void:
	match(state):
		RUNNING:
			move_state(delta)

func standing_state(delta: float):
	pass

func move_state(delta: float):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("KEY_RIGHT") - Input.get_action_strength("KEY_LEFT")
	input_vector.y = Input.get_action_strength("KEY_DOWN") - Input.get_action_strength("KEY_UP")
	input_vector = input_vector.normalized()

	rotation_degrees = rad2deg(get_angle_to(get_global_mouse_position()) + rotation) + 90
	
	if input_vector != Vector2.ZERO:
		direction_vector = input_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	if Input.is_action_just_pressed("PRIMARY"):
		shoot()
		
	if Input.is_action_just_pressed("SECONDARY"):
		absorb()
		
	if Input.is_action_just_released("SECONDARY"):
		stopAbsorbing()
		
	move()

func shoot():
	if (ammo <= 0): return
	if !AbsorbCollision.disabled: return
	AnimationState.travel("Shooting")
	ammo = ammo - 1
	onAmmoSet()
	ShootingSFX.play()
	var bullet = Bullet_Scene.instance()
	bullet.global_position = global_position + Vector2(-10, 0).rotated(deg2rad(rotation_degrees + 90))
	bullet.apply_impulse(Vector2(0,0).rotated(deg2rad(rotation_degrees + 90)), Vector2(BULLET_SPEED, 0).rotated(deg2rad(rotation_degrees - 90)))
	get_parent().add_child(bullet)

func absorb():
	print("Absorb enabled")
	if (AbsorbCollision.disabled):
		OnSuctionStartSFX.play()
		AnimationState.travel("Suction")
		SuctionEmitter1.emitting = true
		SuctionEmitter1.visible = true
		SuctionEmitter2.emitting = true
		SuctionEmitter2.visible = true
		SuctionEmitter3.emitting = true
		SuctionEmitter3.visible = true
	AbsorbCollision.disabled = false

func stopAbsorbing():
	print("Absorb disabled")
	AnimationState.travel("Walking")
	OnSuctionStartSFX.stop()
	OnSuctionFinishSFX.play()
	AbsorbCollision.disabled = true
	SuctionEmitter1.emitting = false
	SuctionEmitter1.visible = false
	SuctionEmitter2.emitting = false
	SuctionEmitter2.visible = false
	SuctionEmitter3.emitting = false
	SuctionEmitter3.visible = false

func move():
	velocity = move_and_slide(velocity)

func _on_AbsorbArea_body_entered(body: Node) -> void:
	body.queue_free()
	ammo += 1
	OnSuctionSFX.play()
	onAmmoSet()
	

func onShootingAnimationFinish():
	AnimationState.travel("Walking")

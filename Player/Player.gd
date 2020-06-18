extends KinematicBody2D

export var ACCELERATION = 2000
export var MAX_SPEED = 200
export var FRICTION = 800
export var BULLET_SPEED = 400


onready var HurtSFXCollection = [
	"res://Player/SFX/Player - Hurt 1.ogg",
	"res://Player/SFX/Player - Hurt 2.ogg",
	"res://Player/SFX/Player - Hurt 3.ogg"
]

onready var AnimationT = $SpriteNodes/AnimationTree
onready var AnimationState = AnimationT.get("parameters/playback")

onready var Bullet_Scene = preload("res://Bullet/Bullet.tscn")
onready var AbsorbCollision = $AbsorbArea/AbsorbCollision
onready var SuctionEmitter1 = $AbsorbArea/SuctionEmitter1
onready var SuctionEmitter2 = $AbsorbArea/SuctionEmitter2
onready var SuctionEmitter3 = $AbsorbArea/SuctionEmitter3

#SFX
onready var OnDashSFX = $SFX/DashSFX
onready var OnHurtPlayerSFX = $SFX/OnHurtSFX
onready var ShootingSFX = $SFX/ShootingSFX
onready var OnSuctionSFX = $SFX/OnSuctionSFX
onready var OnSuctionStartSFX = $SFX/SuctionPowerUpSFX
onready var OnSuctionFinishSFX = $SFX/SuctionPowerDownSFX
onready var OnCrystalPickuSFX = $SFX/CrystalPickupSFX
onready var OutOfAmmoSFX = $SFX/OutOfAmmo
onready var FootstepsSFX = $SFX/FootstepsSFX

var ammo = 3
var crystalsCollected = 0
var health = 25

var lerpVal = 1.0


var bCanDash = true
var dashTimer = 0.0
var dash_recovery_time = 0.5
var isDashin = false
var dash_multiplier = 2.7

var input_vector




#for some reason setget doesn't work. IDK why can't be asked to solve it
signal AmmoChange
func onAmmoSet():
	emit_signal("AmmoChange", ammo)

signal CrystalCollectedChange
func onCrystalCollectedChange():
	emit_signal("CrystalCollectedChange", crystalsCollected)

signal HealthChange
func onHealthChange():
	emit_signal("HealthChange", health)


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
	


func _process(delta):
	if(lerpVal > 1.0):
		lerpVal = 1.0
	else:
		lerpVal += 1.0/ 100.0
	modulate = Color(1,lerpVal,lerpVal)
	
#	print(health)
	if(health <= 0):
		KillPlayer()
		
		
	if(bCanDash == false):
		dashTimer += delta
	if(dashTimer >= dash_recovery_time):
		bCanDash = true
		dashTimer = 0

func KillPlayer():
	get_tree().change_scene("res://DeathScreen/DeathScreen.tscn")


func take_damage(damage):
	OnHurtPlayerSFX.filename
	
	OnHurtPlayerSFX.stream = load(HurtSFXCollection[randi()%HurtSFXCollection.size()])
	OnHurtPlayerSFX.play()
	
	health -= damage
	onHealthChange()
	lerpVal = 0
	modulate = Color(1,lerpVal,lerpVal)
	$Camera2D.small_shake()

func move_state(delta: float):
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("KEY_RIGHT") - Input.get_action_strength("KEY_LEFT")
	input_vector.y = Input.get_action_strength("KEY_DOWN") - Input.get_action_strength("KEY_UP")
	input_vector = input_vector.normalized()

	rotation_degrees = rad2deg(get_angle_to(get_global_mouse_position()) + rotation) + 90
	
	if input_vector != Vector2.ZERO:
		if (!FootstepsSFX.playing):
			FootstepsSFX.play()

		direction_vector = input_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		if (FootstepsSFX.playing):
			FootstepsSFX.stop()
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	if Input.is_action_just_pressed("PRIMARY"):
		shoot()
		
	if Input.is_action_pressed("SECONDARY"):
		absorb()
		
	if Input.is_action_just_released("SECONDARY"):
		stopAbsorbing()
		
	if Input.is_key_pressed(KEY_SPACE):
		if bCanDash:
			dash()
	move()

func dash():
	print("dash")
	if (isDashin): return
	stopAbsorbing()
	isDashin = true
	AnimationState.travel("Dash")
	OnDashSFX.play()
	bCanDash = false
	velocity = velocity.move_toward(input_vector * MAX_SPEED*dash_multiplier, ACCELERATION*10)
	if($Camera2D != null):
		$Camera2D.small_shake()

func onDashFinish():
	print("dash finish")
	isDashin = false
	AnimationState.travel("Walking")

func shoot():
	if (isDashin): return
	if (ammo <= 0):
		OutOfAmmoSFX.play()
		return
	if !AbsorbCollision.disabled: return
	AnimationState.travel("Shooting")
	ammo = ammo - 1
	onAmmoSet()
	ShootingSFX.play()
	var bullet = Bullet_Scene.instance()
	bullet.set_collision_mask_bit(2,true)
	bullet.global_position = global_position + Vector2(-10, 0).rotated(deg2rad(rotation_degrees + 90))
	bullet.apply_impulse(Vector2(0,0).rotated(deg2rad(rotation_degrees + 90)), Vector2(BULLET_SPEED, 0).rotated(deg2rad(rotation_degrees - 90)))
	get_parent().add_child(bullet)

func absorb():
#	print("Absorb enabled")
	if (isDashin): return
	if (AbsorbCollision.disabled):
		OnSuctionStartSFX.play()
		AnimationState.travel("Suction")
		SuctionEmitter1.emitting = true
		SuctionEmitter1.modulate.a = 1
		SuctionEmitter1.speed_scale = 1
		SuctionEmitter2.emitting = true
		SuctionEmitter2.modulate.a = 1
		SuctionEmitter2.speed_scale = 1
		SuctionEmitter3.emitting = true
		SuctionEmitter3.modulate.a = 1
		SuctionEmitter3.speed_scale = 1
		AbsorbCollision.disabled = false

func stopAbsorbing():
#	print("Absorb disabled")
	if (!isDashin):
		AnimationState.travel("Walking")
	OnSuctionStartSFX.stop()
	OnSuctionFinishSFX.play()
	AbsorbCollision.disabled = true
	SuctionEmitter1.emitting = false
	SuctionEmitter1.speed_scale = 10000
	SuctionEmitter1.modulate.a = 0
	SuctionEmitter2.emitting = false
	SuctionEmitter2.modulate.a = 0
	SuctionEmitter2.speed_scale = 10000
	SuctionEmitter3.emitting = false
	SuctionEmitter3.modulate.a = 0
	SuctionEmitter3.speed_scale = 10000

func move():
	velocity = move_and_slide(velocity)



func _on_AbsorbArea_body_entered(body: Node) -> void:
	if (body.filename == 'res://Bullet/Bullet.tscn'):
		if(body.color == "green"):
			ammo += 1
			onAmmoSet()
#			print("Absorbed something")
			body.queue_free()
			OnSuctionSFX.play()
	elif (body.filename == 'res://Crystal/Crystal.tscn'):
#		print("Absorbed a crystal")
		crystalsCollected += 1
		OnCrystalPickuSFX.play()
		onCrystalCollectedChange()
#		print("Absorbed something")
		body.queue_free()
		OnSuctionSFX.play()
	

func onShootingAnimationFinish():
	print("shoot finish")
	AnimationState.travel("Walking")


func getVectorToTransform(target):
	return -(get_transform().origin - target.get_transform().origin).normalized()



func _on_ImpactArea_body_entered(body):
#	print(body.name)
	if (body.filename == 'res://Bacteria/Bacteria.tscn'):
		take_damage(1)
		velocity = velocity.move_toward(-getVectorToTransform(body) * MAX_SPEED, ACCELERATION)
	elif (body.filename == 'res://Bosses/BigBoi/BigBoi.tscn'):
		take_damage(10)
		velocity = velocity.move_toward(-getVectorToTransform(body) * MAX_SPEED*10, ACCELERATION*3)

	elif(body.filename == 'res://Turret/Turret.tscn'):
		pass
		

	elif (body.filename == 'res://Bullet/Bullet.tscn'):
		if(body.color == "blue"):
			take_damage(1)
		if(body.source == "turret"):
			velocity = velocity.move_toward(-getVectorToTransform(body) * MAX_SPEED, ACCELERATION)

#	print(body.filename)

extends StaticBody2D

export var Health = 5
export var AmoutOfComponentsGeneratedAtDeath = 5

onready var bulletScene = preload("res://Bullet/Bullet.tscn")
onready var crystalScene = preload("res://Crystal/Crystal.tscn")
onready var Bullet_Scene = preload("res://Bullet/Bullet.tscn")

onready var AnimationPlayerNode = $Sprite/SpriteAnimations



export var BULLET_SPEED = 300


#SFX
onready var DeathSFX = $SFX/Death
onready var HitSFX = $SFX/Hit
onready var ShootingSFX = $SFX/Shoot


var dead = false
var bIncrementRecoveryTimer = false;
var lerpVal = 1.0

var visionDistance = 600
var recoverytimer = 0
var shootIntervalTimer = 0
var shootIntervalTime =  2
var recoveryTime = 2

onready var player = get_parent().get_node("../Player")
var bCanSeePlayer = false;
var velocity = Vector2.ZERO



func _on_ImpactArea_body_entered(body: Node) -> void:
	
	if(body.color == "green"):
		HitSFX.play()
		Health -= 1
		if (Health <= 0 && !dead):
			onDeath()
		print("hit")
		bIncrementRecoveryTimer = true;
		
		lerpVal = 0.0
	

func shoot():
	AnimationPlayerNode.play("Shoot")
	ShootingSFX.play()
	var bullet = Bullet_Scene.instance()
	bullet.color = "blue"
	bullet.bShouldDie = true
#	bullet.set_collision_layer_bit(2,false)
#	bullet.set_collision_layer_bit(3,false)
	bullet.global_position = global_position + Vector2(-10, 0).rotated(deg2rad(rotation_degrees + 90))
	#bullet.apply_impulse(Vector2(0,0).rotated(deg2rad(rotation_degrees + 90)), Vector2(BULLET_SPEED, 0).rotated(deg2rad(rotation_degrees - 90)))
	bullet.apply_impulse(Vector2(0,0).rotated(deg2rad(rotation_degrees + 90)), getVectorToTransform(player)*BULLET_SPEED)
	get_parent().add_child(bullet)


func onDeath():
	dead = true
	DeathSFX.play()
	AnimationPlayerNode.play("Death")
	print("DYING")

func onDeathAnimationComplete():
	print("DEAD")
	queue_free()
	generateComponent(crystalScene)
	for i in range(AmoutOfComponentsGeneratedAtDeath):
		generateComponent(bulletScene)
		

func _process(delta):
	shootIntervalTimer += delta
	if(bIncrementRecoveryTimer):
		recoverytimer += delta
	if(recoverytimer >= recoveryTime):
		recoverytimer = 0
		bIncrementRecoveryTimer = false
	if(bCanSeePlayer && recoverytimer == 0):
		if(shootIntervalTimer >= shootIntervalTime):
			shoot()
			shootIntervalTimer = 0

		
		
		
		
	if(lerpVal > 1.0):
		lerpVal = 1.0
	else:
		lerpVal += 1.0/ 100.0
	$Sprite.modulate = Color(1,lerpVal,lerpVal)
	
	
	update()
	
	
	
	
func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
#	set_collision_layer_bit(1,true)
#	set_collision_mask_bit(2,true)
	var hit = space_state.intersect_ray(get_transform().origin, get_transform().origin+getVectorToTransform(player)*visionDistance,[self],collision_mask)
	if hit:
		if(hit["collider"] == player):
			bCanSeePlayer = true;
		else:
			bCanSeePlayer = false;
			#put code for whatever it does there

func _draw():
	pass
#	draw_line(Vector2(0,0), getVectorToTransform(player)*visionDistance, Color(255, 0, 0), 1)




func followPlayer(player,delta):
	if (AnimationPlayerNode.current_animation != "Death"):
		AnimationPlayerNode.play("Movement")
	
	var direction = getVectorToTransform(player)
	velocity = velocity.move_toward(direction * 1, 1 * delta)
	position += velocity;

func getVectorToTransform(target):
	return -(get_transform().origin - target.get_transform().origin).normalized()

func generateComponent(scene):
	var impulseForce = 50
	var component = scene.instance()
	var direction_rotation = deg2rad((randi()%360+0) + 90)
	print(direction_rotation)
	var pos = global_position + Vector2(10,0).rotated(direction_rotation)
	component.global_position = pos
	get_parent().add_child(component)
	component.global_position = global_position + Vector2(-10, 0).rotated(deg2rad(rotation_degrees + 90))
	component.apply_impulse(Vector2(20, 0).rotated(direction_rotation),
				  Vector2(impulseForce, 0).rotated(direction_rotation))

extends RigidBody2D

onready var VocalTracks = [
	"res://Bosses/BigBoi/SFX/Enemy - Boss Vocal 01.ogg",
	"res://Bosses/BigBoi/SFX/Enemy - Boss Vocal 02.ogg",
	"res://Bosses/BigBoi/SFX/Enemy - Boss Vocal 03.ogg",
	"res://Bosses/BigBoi/SFX/Enemy - Boss Vocal 04.ogg",
	"res://Bosses/BigBoi/SFX/Enemy - Boss Vocal 05.ogg",
]

onready var VocalsPlayer = $SFX/Vocals
onready var AnimationPlayerNode = $Sprite/AnimationPlayer
onready var crystalScene = preload("res://Crystal/Crystal.tscn")
onready var player = get_parent().get_parent().get_node("../Player")

export var Health = 15
var dead = false
var AmoutOfComponentsGeneratedAtDeath = 5

var bIncrementRecoveryTimer = false;
var lerpVal = 1.0

var bCanSeePlayer = false;
var visionDistance = 600
var recoverytimer = 0
var shootIntervalTimer = 0
var shootIntervalTime =  3
var recoveryTime = 2

var bCanAttack = false

func _ready() -> void:
	pass # Replace with function body.

	
func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	var hit = space_state.intersect_ray(global_position, get_transform().origin+getVectorToTransform(player)*visionDistance,[self],collision_mask)
	if hit:
		if(hit["collider"] == player):
			bCanSeePlayer = true;
		else:
			bCanSeePlayer = false;


func startAttacking():
	bCanAttack = true;

func stopAttacking():
	bCanAttack = false;


func _process(delta):
	
	
	
	shootIntervalTimer += delta
	if(bIncrementRecoveryTimer):
		recoverytimer += delta
	if(recoverytimer >= recoveryTime):
		recoverytimer = 0
		bIncrementRecoveryTimer = false
	if(bCanSeePlayer && recoverytimer == 0 && bCanAttack):
		if(shootIntervalTimer >= shootIntervalTime):
			if (!dead):
				AnimationPlayerNode.play("Attack")
			shootIntervalTimer = 0

	if(lerpVal > 1.0):
		lerpVal = 1.0
	else:
		lerpVal += 1.0/ 100.0
	$Sprite.modulate = Color(1,lerpVal,lerpVal)

	update()


func _draw():
	draw_line(Vector2(0,0), (getVectorToTransform(player)*visionDistance).rotated(deg2rad(-rotation_degrees)), Color(255, 0, 0), 1)



#on contact with bullet
func _on_HitArea_body_entered(body: Node) -> void:
	
	if(body.filename == "res://Bullet/Bullet.tscn"):
		if(body.color == "green"):
			print("You hit big boi, you get big slap!")
			Health -= 1
			VocalsPlayer.stream = load(VocalTracks[randi()%VocalTracks.size()])
			VocalsPlayer.play()
			if (Health <= 0 && !dead):
				onDeath()
			bIncrementRecoveryTimer = true;
			lerpVal = 0.0


func onDeath():
	dead = true
	AnimationPlayerNode.play("Death")
	print("DYING")

func onCrystalDrop():
	for i in range(AmoutOfComponentsGeneratedAtDeath):
		createCrystal(true)
	createCrystal(false)

func onDeathAnimationComplete():
	print("DEAD")
	queue_free()


func getVectorToTransform(target):
	var OriginDir = -(global_position - target.get_transform().origin)
	return OriginDir.normalized()

func impulseToPlayer():
	print("impulsing")
	var impulseForce = 1000
	var direction_rotation = deg2rad((randi()%360+0) + 90)
	
	apply_impulse(Vector2(20, 0).rotated(direction_rotation),
				  getVectorToTransform(player) * impulseForce)

func createCrystal(shouldIgnoreSound):
	var scene = crystalScene
	var impulseForce = 50
	var component = scene.instance()
	component.shouldIgnoreSound = shouldIgnoreSound
	var direction_rotation = deg2rad((randi()%360+0) + 90)
	print(direction_rotation)
	var pos = global_position + Vector2(10,0).rotated(direction_rotation)
	component.global_position = pos
	get_parent().get_parent().add_child(component)
	component.global_position = global_position + Vector2(-10, 0).rotated(deg2rad(rotation_degrees + 90))
	component.apply_impulse(Vector2(20, 0).rotated(direction_rotation),
				  Vector2(impulseForce, 0).rotated(direction_rotation))



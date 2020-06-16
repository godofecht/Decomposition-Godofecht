extends RigidBody2D

export var Health = 5
export var AmoutOfComponentsGeneratedAtDeath = 5

onready var bulletScene = preload("res://Bullet/Bullet.tscn")
onready var crystalScene = preload("res://Crystal/Crystal.tscn")

onready var AnimationPlayerNode = $Sprite/AnimationPlayer
#SFX
onready var DeathSFX = $SFX/Death
onready var HitSFX = $SFX/Hit

var dead = false

func _integrate_forces(state):
	inertia = 1000000

func _ready() -> void:
	var impulseForce = 25
	var direction_rotation = deg2rad((randi()%360+0))
	apply_impulse(Vector2(20, 0).rotated(direction_rotation),
				  Vector2(impulseForce, 0).rotated(direction_rotation))
	

func _on_ImpactArea_body_entered(body: Node) -> void:
	HitSFX.play()
	Health -= 1
	if (Health <= 0 && !dead):
		onDeath()
	print("hit")

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

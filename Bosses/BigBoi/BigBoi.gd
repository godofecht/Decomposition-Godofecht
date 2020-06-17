extends RigidBody2D

onready var AnimationPlayerNode = $Sprite/AnimationPlayer
onready var crystalScene = preload("res://Crystal/Crystal.tscn")
onready var player = get_parent().get_node("../Player")

var dead = false
var AmoutOfComponentsGeneratedAtDeath = 5

func _ready() -> void:
	pass # Replace with function body.

func _on_HitArea_body_entered(body: Node) -> void:
	print("You hit big boi, you get big slap!")
	AnimationPlayerNode.play("Attack")
	pass # Replace with function body.

func onDeath():
	dead = true
	AnimationPlayerNode.play("Death")
	print("DYING")

func onDeathAnimationComplete():
	print("DEAD")
	queue_free()
	
	for i in range(AmoutOfComponentsGeneratedAtDeath):
		generateComponent(crystalScene)

func getVectorToTransform(target):
	return -(get_transform().origin - target.get_transform().origin).normalized()

func impulseToPlayer():
	print("impulsing")
	var impulseForce = 1000
	var direction_rotation = deg2rad((randi()%360+0) + 90)
	
	apply_impulse(Vector2(20, 0).rotated(direction_rotation),
				  getVectorToTransform(player) * impulseForce)

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

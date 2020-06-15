extends RigidBody2D

var Health = 5

onready var bulletScene = preload("res://Bullet/Bullet.tscn")

func _on_ImpactArea_body_entered(body: Node) -> void:
	Health -= 1
	if (Health <= 0):
		onDeath()
	print("hit")

func onDeath():
	print("DEAD")
	queue_free()
	generateBacteriaComponent()
	generateBacteriaComponent()
	generateBacteriaComponent()
	generateBacteriaComponent()
	


func generateBacteriaComponent():
	var impulseForce = 50
	
	var bullet = bulletScene.instance()
	var direction_rotation = deg2rad((randi()%360+0) + 90)
	print(direction_rotation)
	var pos = global_position + Vector2(10,0).rotated(direction_rotation)
	bullet.global_position = pos
	get_parent().add_child(bullet)
	bullet.global_position = global_position + Vector2(-10, 0).rotated(deg2rad(rotation_degrees + 90))
	bullet.apply_impulse(Vector2(20, 0).rotated(direction_rotation),
				  Vector2(impulseForce, 0).rotated(direction_rotation))

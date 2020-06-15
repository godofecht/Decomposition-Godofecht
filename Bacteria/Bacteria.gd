extends RigidBody2D

var Health = 5

func _on_ImpactArea_body_entered(body: Node) -> void:
	Health -= 1
	if (Health <= 0):
		print("DEAD")
		queue_free()
		
	print("hit")

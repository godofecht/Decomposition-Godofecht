extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	queue_free()

func _physics_process(delta:float):
	print(get_colliding_bodies())
	for body in get_colliding_bodies():
#		print(body)
		if(body.filename == 'res://Player/Player.tscn'):
			print("cool")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

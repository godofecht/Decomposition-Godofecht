extends RigidBody2D

onready var animationPlayer = $Sprite/AnimationPlayer

export var color = "green"
var source = ""




var bShouldDie = false
var life_timer = 0
var lifespan = 2

func _ready() -> void:
	animationPlayer.play(color)



func _process(delta):
	if(bShouldDie):
		life_timer += delta
#		print(life_timer)

	if(life_timer >= lifespan):
		life_timer = 0
		queue_free()

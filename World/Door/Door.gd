extends StaticBody2D

onready var collisionShape = $Collision
onready var sprite = $Sprite
onready var openingSFX = $OpeningSound

var isOpen = false

func open():
	openingSFX.play()
	isOpen = true
	sprite.frame = 1
	collisionShape.disabled = true
	
func close():
	isOpen = false
	sprite.frame = 0
	collisionShape.disabled = false

extends Area2D

onready var transition = $"Transition"

export var keep_stuff = true
export var nextLevel = "res://DeathScreen/DeathScreen.tscn"

var colorRectForTransition

var body

var hasTransitionStarted = false

func _on_NextLevelArea_body_entered(b):
	if(b.name != "Player"): return
	if (hasTransitionStarted): return
	body = b
	hasTransitionStarted = true
	if (colorRectForTransition == null):
		moveTo()
		return
	transition.colorRect = colorRectForTransition
	transition.fadeIn()

func moveTo():
	if (keep_stuff):
		Global.player_health = body.health
		Global.player_bullets = body.ammo
		Global.player_crystals = body.crystalsCollected
	print("Moving to ")
	print(nextLevel)
	if (nextLevel != "res://DeathScreen/DeathScreen.tscn"):
		Global.CURRENT_LEVEL_SCENE = nextLevel
	get_tree().change_scene(nextLevel)


func _on_Transition_tween_completed(object: Object, key: NodePath) -> void:
	moveTo()

extends Area2D

export var nextLevel = "res://DeathScreen/DeathScreen.tscn"

func _on_NextLevelArea_body_entered(body):
	if(body.name == "Player"):
		print("Moving to ")
		print(nextLevel)
		if (nextLevel != "res://DeathScreen/DeathScreen.tscn"):
			Global.CURRENT_LEVEL_SCENE = nextLevel
		get_tree().change_scene(nextLevel)

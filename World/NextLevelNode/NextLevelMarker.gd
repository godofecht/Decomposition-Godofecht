extends Area2D

export var keep_stuff = true
export var nextLevel = "res://DeathScreen/DeathScreen.tscn"

func _on_NextLevelArea_body_entered(body):
	if(body.name == "Player"):
		if (keep_stuff):
			Global.player_health = body.health
			Global.player_bullets = body.ammo
			Global.player_crystals = body.crystalsCollected
		print("Moving to ")
		print(nextLevel)
		if (nextLevel != "res://DeathScreen/DeathScreen.tscn"):
			Global.CURRENT_LEVEL_SCENE = nextLevel
		get_tree().change_scene(nextLevel)

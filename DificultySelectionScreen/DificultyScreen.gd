extends Node2D

var firstLevel = "res://World/Levels/Level1/Level1.tscn"


func _on_Easy_body_shape_entered(body_id: int, body: Node, body_shape: int, area_shape: int) -> void:
	if(body.name == "Player"):
		Global.player_health = 100
		Global.TOTAL_HP = Global.player_health
		Global.player_bullets = 10
		startTransition()


func _on_Hard_body_shape_entered(body_id: int, body: Node, body_shape: int, area_shape: int) -> void:
	if(body.name == "Player"):
		Global.player_health = 25
		Global.TOTAL_HP = Global.player_health
		Global.player_bullets = 3
		startTransition()

func _on_Insane_body_shape_entered(body_id: int, body: Node, body_shape: int, area_shape: int) -> void:
	if(body.name == "Player"):
		Global.player_health = 5
		Global.TOTAL_HP = Global.player_health
		Global.player_bullets = 1
		startTransition()

func startTransition():
	$Transition.colorRect = $ColorRect
	$Transition.fadeIn()

func changeLevel():
	Global.player_crystals = 0
	print("Moving to ")
	print(firstLevel)
	Global.CURRENT_LEVEL_SCENE = firstLevel
	get_tree().change_scene(firstLevel)


func _on_Transition_tween_completed(object: Object, key: NodePath) -> void:
	changeLevel()

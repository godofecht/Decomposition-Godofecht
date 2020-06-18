extends Area2D

onready var LevelMusic = $"../SFX/MusicBG"
onready var BossMusic = $"BossMusic"


func _on_BossTrigger_body_entered(body: Node) -> void:
	LevelMusic.stop()
	BossMusic.play()

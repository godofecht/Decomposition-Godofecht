extends Node2D

onready var AmmoUI = $UI/HUD/Ammo
onready var Shadows = $Map/Shadows

onready var LevelMusic = $"SFX/MusicBG"
onready var BossMusic = $"SFX/BossMusic"


func _ready() -> void:
	Shadows.visible = true

onready var AreaDoorMapping = [	
	[$"YSort - Entities/Enemies/Area1", $"Doors/Door"],	
	[$"YSort - Entities/Enemies/Area2", $"Doors/Door2"],	
	[$"YSort - Entities/Enemies/Area3", $"Doors/Door3"]	
]	

func _process(delta: float) -> void:	
	for A2D in AreaDoorMapping:	
		if (A2D[1] == null): return	

		if (A2D[0].get_child_count() <= 0 && !A2D[1].isOpen):	
			A2D[1].open()	

func _on_Player_AmmoChange(value) -> void:	
	AmmoUI.text = "%s" % value	


func _on_BossTrigger_body_entered(body: Node) -> void:
	LevelMusic.stop()
	BossMusic.play()

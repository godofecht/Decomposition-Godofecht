extends Node2D

onready var Notification = $UI/Notification

onready var AmmoUI = $UI/HUD/Ammo
onready var HealthUI = $UI/HUD/Health
onready var CrystalUI = $UI/HUD/Crystals
onready var Shadows = $Map/Shadows

onready var LevelMusic = $"SFX/MusicBG"
onready var BossMusic = $"SFX/BossMusic"

onready var Player = $"YSort - Entities/Player"

func _ready() -> void:
	Shadows.visible = true
	Player.health = Global.player_health
	Player.ammo = Global.player_bullets
	Player.crystalsCollected = Global.player_crystals
	_on_Player_HealthChange(Player.health)
	_on_Player_AmmoChange(Player.ammo)
	_on_Player_CrystalCollectedChange(Player.crystalsCollected)
	Notification.showText("Level 3")
	$Transition.colorRect = $ColorRect
	$ColorRect.modulate.a = 1
	$NextLevelArea.colorRectForTransition = $ColorRect
	$Transition.fadeOut()
	
onready var AreaDoorMapping = [	
	[$"YSort - Entities/Enemies/Area1", $"Doors/Door"],	
	[$"YSort - Entities/Enemies/Area2", $"Doors/Door2"],	
	[$"YSort - Entities/Enemies/Area3", $"Doors/Door3"]	
]	

func _process(delta: float) -> void:	
	for A2D in AreaDoorMapping:	
		if (A2D[1] == null || A2D[0] == null): return

		if (A2D[0].get_child_count() <= 0 && !A2D[1].isOpen):	
			A2D[1].open()	

func _on_Player_AmmoChange(value) -> void:	
	AmmoUI.text = "%s" % value


var hasEntered = false

func _on_BossTrigger_body_entered(body: Node) -> void:
	if (!hasEntered):
		hasEntered = true
		Notification.showText("Cereus")
		LevelMusic.stop()
		BossMusic.play()


func _on_Player_CrystalCollectedChange(value) -> void:
	CrystalUI.text = "%s" % value	


func _on_Player_HealthChange(value) -> void:
	HealthUI.text = "%s/%s" % [value, Global.TOTAL_HP]

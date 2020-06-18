extends Camera2D

func _process(delta):
#	small_shake()
	pass

func small_shake():
	$ScreenShake.start(0.1, 15, 4, 0)



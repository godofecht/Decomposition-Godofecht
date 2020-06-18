extends Tween

onready var t = self
var colorRect
var fadeTime = 0.5

func fadeIn():
	if (colorRect == null): return
	t.interpolate_property(colorRect, "modulate:a", 0,1, fadeTime, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	t.start()

func fadeOut():
	if (colorRect == null): return
	t.interpolate_property(colorRect, "modulate:a",  1,0, fadeTime, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	t.start()
